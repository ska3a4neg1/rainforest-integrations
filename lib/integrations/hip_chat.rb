module Integrations
  class HipChat < Base
    def self.key
      "hip_chat"
    end

    def send_event
      response = HTTParty.post(url,
        body: {
          color: message_color,
          message: message_text,
          notify: 'true',
          message_format: 'text'
        }.to_json,
        headers: {
          "Authorization" => "Bearer #{settings[:auth_token]}",
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        }
      )
    end

    private

    def url
      "https://api.hipchat.com/v2/room/#{settings[:room_id]}/notification"
    end

    def message_color
      return 'red' if payload[:run] && payload[:run][:status] == 'failed'

      color_hash = {
        'run_completion' => "green",
        'run_error' => "red",
        'run_webhook_timeout' => "red",
        'run_test_failure' => "red",
      }

      color_hash[event_name]
    end
  end
end
