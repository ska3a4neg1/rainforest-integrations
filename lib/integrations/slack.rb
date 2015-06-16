class Integrations::Slack
  def initialize(event_name, payload, settings)
    @event_name = event_name
    @payload = payload
    @settings = settings
  end

  def send_event
    
  end
end
