module Integrations
  class HipChat < Base
    def send_event
      response = HTTParty.post(url,
        body: {
          color: 'green',
          message: 'Test successful!',
          notify: 'true',
          message_format: 'text'
        },
        headers: {
          "Authorization" => settings[:auth_token],
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        }
      )
    end

    def url
      "https://api.hipchat.com/v2/room/#{settings[:room_id]}/notification"
    end
  end
end
