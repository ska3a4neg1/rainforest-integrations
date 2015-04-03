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
        return if config.hipchat_room.empty? || config.hipchat_token.empty?

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
      rescue Http::Exceptions::HttpException => ex
        case ex.response.code
        when 400..499
          msg = ex.response.body["error"]["message"]
          raise ConfigurationError.new(msg, original_exception: ex)
        else
          raise ex
        end
      end
    end
  end
end
