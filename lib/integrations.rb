require 'active_support/inflector'
require 'event_validator'

module Integrations
  INTEGRATIONS = %w(slack)
  INTEGRATIONS.each { |i| require "integrations/#{i}" }

  class UnsupportedIntegrationError < StandardError
    def initialize(integration_name)
      super "Integration '#{integration_name}' is not supported"
    end
  end

  class MisconfiguredIntegrationError < StandardError
    def initialize(setting)
      super "Required setting '#{setting}' was not supplied"
    end
  end

  def self.send_event(event_name: , integrations: , payload: )
    EventValidator.new(event_name, payload).validate!

    integrations.each do |integration|
      integration_name = INTEGRATIONS.find { |i| i == integration[:key] }
      raise UnsupportedIntegrationError, integration[:key] unless integration_name

      klass_name = "Integrations::#{integration_name.classify}".constantize
      integration_object = klass_name.new(event_name, payload, integration[:settings])
      integration_object.send_event
    end
  end
end
