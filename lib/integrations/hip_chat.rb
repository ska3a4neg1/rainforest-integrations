module Integrations
  class HipChat < Base
    def self.key
      "hip_chat"
    end

    def send_event
      response = HTTParty.post(url,
        body: {
          color: 'green',
          message: 'Test successful!',
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

    def message

    end
  end
end
