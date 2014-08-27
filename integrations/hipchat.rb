module Rainforest
  module Integrations
    class Hipchat < Base
      include HttpIntegration
      include HtmlRenderer

      URL = "https://api.hipchat.com/v1/rooms/message".freeze

      config do
        string :hipchat_room
        string :hipchat_token
      end

      def on_event(event)
        message = render_html(event)
        body = {
          room_id: config.hipchat_room,
          from: "Rainforest QA",
          message: message,
          message_format: 'html',
          notify: false,
          color: event.failure? ? 'red' : 'green',
          auth_token: config.hipchat_token,
        }
        post URL, body: body
      end
    end
  end
end

