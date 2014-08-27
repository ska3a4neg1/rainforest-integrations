module Rainforest
  module Integrations
    class Pivotal < Base
      include HttpIntegration
      include HtmlRenderer
      include TextRenderer

      config do
        string :pivotal_api_token
        string :pivotal_project_id
      end

      receive_events "test_failure"

      def on_event(event)
        body = {
          name: render_text(event),
          description: description(event),
          story_type: 'bug',
          labels: [{name: 'rainforest'}]
        }.to_json

        post(url, body: body, headers: {
          'Content-Type' => 'application/json',
          'X-TrackerToken' => config.pivotal_api_token,
          'User-Agent' => 'Rainforest QA'
        })
      end

      def url
        "https://www.pivotaltracker.com/services/v5/projects/#{config.pivotal_project_id}/stories"
      end

      def description(event)
        browser_result = event.browser_result
        txt = %{The following errors were reported for you test '#{browser_result["failing_test"]["title"]}' (#{event.ui_link}) in #{browser_result["browser"]} for run #{browser_result["run_id"]}:\n\n}

        browser_result["failing_test"]["steps"].each.with_index do |step, i|
          r = step["browsers"].first
          txt << "Step ##{i+1} #{r["result"]}: #{step["action"]} - #{step["response"]}\n"

          r["feedback"].each do |feedback|
            txt << "#{feedback["note"]}, #{feedback["user_agent"]} @ #{feedback["submitted_at"]}\n"
            unless feedback["screenshots"].empty?
              txt << "Screenshot: #{feedback["screenshots"].map { |s| s["url"] }.join(", ")}\n"
            end
          end
        end

        txt
      end
    end
  end
end


