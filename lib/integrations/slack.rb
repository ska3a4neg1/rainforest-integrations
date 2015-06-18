require "integrations/base"

class Integrations::Slack < Integrations::Base
  def send_event
    # send it to the integration
    HTTParty.post(url,
      :body => {
        :attachments => [{
          :text => message_text[event_name],
          :fallback => message_text[event_name],
          :color => message_color[event_name]
        }]
      }.to_json,
      :headers => {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    )
  end

  private

  def message_text
    {
      'run_completion' => "Run #{@payload[:id]} completed",
      'run_error' => "Run #{@payload[:id]} error",
      'run_webhook_timeout' => "Webhook of run #{@payload[:id]} timed out",
      'run_test_failure' => "Run test #{@payload[:id]} failed",
    }
  end

  def message_color
    {
      'run_completion' => "good",
      'run_error' => "danger",
      'run_webhook_timeout' => "danger",
      'run_test_failure' => "danger",
    }
  end

  def required_settings
    %i(url)
  end

  def url
    settings[:url]
  end
end
