require "ostruct"
require "httparty"
require 'http/exceptions'
require "active_support/inflector"
require "rainforest/integrations/version"
require "rainforest/integrations/base"
require "rainforest/integrations/event"
require "rainforest/integrations/config/config"
require "rainforest/integrations/http_integration"
require "rainforest/integrations/html_renderer"
require "rainforest/integrations/text_renderer"


module Rainforest
  module Integrations
    INTEGRATIONS = %w(
      test_integration
      hipchat
      pivotal
    ).freeze

    root = Pathname.new(File.dirname(__FILE__)).join("../..")
    INTEGRATIONS.each do |integration|
      require root.join("integrations", integration)
    end

    # Your code goes here...
    def self.send_event(integration, event: , config: )
      event = convert_arguments(Event, event) { |event| Event.new(event) }
      integration = convert_arguments(Base, integration) do |integration|
        self.const_get(ActiveSupport::Inflector.camelize(integration)).new(config)
      end

      integration.on_event(event) if integration.supports_event?(event.type)
    end

    private
    def self.convert_arguments(klass, arg)
      raise ArgumentError unless block_given?
      if arg.is_a?(klass)
        arg
      else
        yield arg
      end
    end
  end
end
