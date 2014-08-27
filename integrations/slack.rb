require "active_support/core_ext/string/strip"

module Rainforest
  module Integrations
    class Slack < Base
      include HttpIntegration
      include TextRenderer

      config do
        string :slack_url
      end

      def on_event(event)
        data = render_event(event)

        body = {attachments: [ data ]}

        post url, body: data
      end

      def render_event(event)
        data = {
          fallback: render_text(event),
          color: "#278d3f",
          mrkdwn_in: [:text, :fields]
        }

        if browser_result = event.browser_result
          data[:pretext] = <<-MKD.strip_heredoc
            Errors were reported for your test
            [#{browser_result["failing_test"]["title"].inspect}](#{event.ui_link})
            in #{browser_result["browser"]} for run #{event.run["id"]}.
          MKD

          steps = browser_result["failing_test"]["steps"]
          data[:fields] = steps.map.with_index do |step, i|
            result = step["browsers"].first
            next unless result["result"] == "failed"
            {
              title: "Step ##{i+1} #{result["result"]}: #{truncate(step["action"])} - #{truncate(step["response"])}",
              value: result["feedback"].map do |feedback|
                txt = "#{feedback["note"]}, #{feedback["user_agent"]} @ #{feedback["submitted_at"]}"
                unless feedback["screenshots"].empty?
                  txt << " Screenshot: #{feedback["screenshots"].map { |s| s["url"] }.join(", ")}\n"
                end
                txt
              end.join("\n")
            }
          end.compact
        else
          data[:pretext] = render_text(event)
        end

        data
      end

      def truncate(str, len: 30)
        str.truncate(len, separator: /\s+/)
      end

      def url
        config.slack_url
      end
    end
  end
end

