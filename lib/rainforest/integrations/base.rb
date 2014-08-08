module Rainforest
  module Integrations
    class Base
      def initialize(config = {})
        @config = config
      end

      def config
        OpenStruct.new(@config)
      end

      def self.config
        # Nothing for now, mostly serves as documentation
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
    end
  end
end
