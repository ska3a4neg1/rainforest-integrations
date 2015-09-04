require 'active_support/inflector'
require 'payload_validator'

module Integrations
  Integration.supported_integrations.each { |i| require "integrations/#{i}" }

  class UnsupportedIntegrationError < StandardError
    def initialize(integration_name)
      super "Integration '#{integration_name}' is not supported"
    end
  end

  class MisconfiguredIntegrationError < StandardError
  end

  class UserConfigurationError < StandardError
  end

  def self.send_event(event_name: , integrations: , payload: )
    PayloadValidator.new(event_name, integrations, payload).validate!

    integrations.each do |integration|
      integration_name = integration[:key]
      raise UnsupportedIntegrationError, integration_name unless Integration.exists? integration_name

      klass_name = "Integrations::#{integration_name.classify}".constantize
      integration_object = klass_name.new(event_name, payload, integration[:settings])
      integration_object.send_event
    end
  end
end
