require 'active_support/inflector'

class Integrations
  class UnsupportedIntegrationError < StandardError
  end

  INTEGRATIONS = %w(slack)
  INTEGRATIONS.each { |i| require "integrations/#{i}" }

  def self.send_event(event_name: , integrations: , payload: )
    integrations.each do |integration|
      integration_name = INTEGRATIONS.find { |i| i == integration[:name] }
      raise UnsupportedIntegrationError unless integration_name

      klass_name = "Integrations::#{integration_name.classify}".constantize
      integration_object = klass_name.new(event_name, payload, integration[:settings])
      integration_object.send_event
    end
  end
end
