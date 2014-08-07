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
        define_method :supports_event? do |event|
          event_types.include?(event)
        end
      end

      def supports_event?(event_type)
        Event.check_event!(event_type)
        true
      end
    end
  end
end
