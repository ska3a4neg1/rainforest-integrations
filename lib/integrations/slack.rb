require 'integrations/base'

class Integrations::Slack < Integrations::Base
  def send_event
  end

  private

  def required_settings
    %i(url)
  end
end
