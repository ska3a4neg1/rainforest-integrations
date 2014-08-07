module Rainforest
  module Integrations
    class Hipchat < Base
      include HttpIntegration

      config do
        string :hitchat_room
        string :hitchat_token
      end

      def on_event(event)
        url = "https://api.hipchat.com/v1/rooms/message"
        message = event.to_html
        body = {
          room_id: config.hitchat_room,
          from: "Rainforest QA",
          message: message,
          message_format: 'html',
          notify: false,
          color: 'green',
          auth_token: config.hitchat_token,
        }
        post url, body: body
      end
    end
  end
end

