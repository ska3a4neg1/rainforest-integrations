module Rainforest
  module Integrations
    class Base
      def initialize(config = {})
        @config = config
      end

      def config
        OpenStruct.new(@config)
      end

      def self.config(&block)
        if block_given?
          @config = Config::Config.new(&block)
        else
          @config
        end
      end

      def self.receive_events(*event_types)
        Event.check_event!(*event_types)
        @supports_events = event_types
      end

      def supports_event?(event_type)
        Event.check_event!(event_type)
        self.class.supported_events.include?(event_type)
      end

      def self.supported_events
        @supports_events || Event::TYPES
      end

      def self.valid_config?(config)
        config.valid?(config)
      end
    end
  end
end
