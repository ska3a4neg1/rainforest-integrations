require "integrations/base"

module Integrations
  class Slack < Base
    def self.key
      'slack'
    end

    def send_event
      # send it to the integration
      response = HTTParty.post(url,
        :body => {
          :attachments => [{
            :text => message_text[event_name],
            :fallback => message_text[event_name],
            :color => message_color
          }]
        }.to_json,
        :headers => {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
      )
      if response.code == 500 && response.parsed_response == 'no_text'
        raise Integrations::MisconfiguredIntegrationError.new('Invalid request to the Slack API (maybe the JSON structure is wrong?).')
      elseif response.code == 404 && response.parsed_response == 'Bad token'
        raise Integrations::UserConfigurationError.new('The provided Slack URL is invalid.')
      elseif response.code != 200
        raise Integrations::MisconfiguredIntegrationError.new('Invalid request to the Slack API.')
      end
    end

    def message_color
      return 'danger' if payload[:run][:status] == 'failed'

      color_hash = {
        'run_completion' => "good",
        'run_error' => "danger",
        'run_webhook_timeout' => "danger",
        'run_test_failure' => "danger",
      }

      color_hash[event_name]
    end

    private

    def message_text
      {
        'run_completion' => "<#{payload[:frontend_url]}|Run #{payload[:id]}> completed.",
        'run_error' => "Error in <#{payload[:frontend_url]}|run #{payload[:id]}>",
        'run_webhook_timeout' => "Webhook of run <#{payload[:frontend_url]}|#{payload[:id]}> timed out",
        'run_test_failure' => "<#{payload[:frontend_url]}|Test #{payload[:id]}> failed!"
      }
    end

    def url
      settings[:url]
    end
  end
end
