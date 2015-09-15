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
            :text => message_text,
            :fallback => message_text,
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
      elsif response.code == 404 && response.parsed_response == 'Bad token'
        raise Integrations::UserConfigurationError.new('The provided Slack URL is invalid.')
      elsif response.code != 200
        raise Integrations::MisconfiguredIntegrationError.new('Invalid request to the Slack API.')
      end
    end

    def message_color
      return 'danger' if payload[:run] && payload[:run][:status] == 'failed'

      color_hash = {
        'run_completion' => "good",
        'run_error' => "danger",
        'run_webhook_timeout' => "danger",
        'run_test_failure' => "danger",
      }

      color_hash[event_name]
    end

    private

    def url
      settings[:url]
    end

    def run_href
      "<#{payload[:frontend_url]} | Run ##{run[:id]}#{run_description}>"
    end

    def test_href
      "<#{payload[:frontend_url]} | Test ##{payload[:failed_test][:id]}: #{payload[:failed_test][:name]}>"
    end
  end
end
