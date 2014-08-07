module Rainforest
  module Integrations
    class Hipchat < Base
      include HttpIntegration

      config do
        string :hipchat_room
        string :hipchat_token
      end

      def on_event(event)
        url = "https://api.hipchat.com/v1/rooms/message"
        message = event.to_html
        body = {
          room_id: config.hipchat_room,
          from: "Rainforest QA",
          message: message,
          message_format: 'html',
          notify: false,
          color: event.failure? ? 'red' : 'green',
          auth_token: config.hipchat_token,
        }
        post url, body: body
      end
    end
  end
end

