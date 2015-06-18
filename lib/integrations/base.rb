require 'integrations'

class Integrations::Base
  attr_reader :event_name, :payload, :settings

  def initialize(event_name, payload, settings)
    validate_settings settings
    @event_name = event_name
    @payload = payload
    @settings = settings
  end

  def send_event
    raise 'send_event must be defined in the child class'
  end

  protected

  def required_settings
    []
  end

  def validate_settings(settings)
    required_settings.each do |setting|
      unless settings.key? setting
        raise Integrations::MisconfiguredIntegrationError, setting
      end
    end
  end
end
