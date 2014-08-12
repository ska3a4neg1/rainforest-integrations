module Rainforest
  module Integrations
    class Pivotal < Base
      include HttpIntegration

      config do
        string :pivotal_api_token
        string :pivotal_project_id
      end

      receive_events "test_failure"

      def on_event(event)
        message = event.to_html

        body = {
          name: event.to_text,
          description: event.to_html,
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
    end
  end
end


