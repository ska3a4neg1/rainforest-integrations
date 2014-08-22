module Rainforest
  module Integrations
    class Event
      attr_reader :name, :run, :browser_result, :type, :is_failure, :ui_link

      TYPES = %w(
        first_failure
        run_failure
        run_success
        test_failure
        test_success
        webhook_timeout
      ).freeze

      def initialize(event_blob)
        @name           = event_blob["name"]
        @run            = event_blob["run"]
        @browser_result = event_blob["browser_result"]
        @type           = event_blob["type"]
        @is_failure     = event_blob["is_failure"]
        @ui_link        = event_blob["ui_link"]


        validate_type!
      end

      def self.check_event!(*types)
        types.each do |type|
          unless TYPES.include?(type)
            raise ArgumentError, "Expected #{type.inspect} to be one of #{TYPES.inspect}"
          end

        end
      end

      def failure?
        @is_failure
      end

      protected

      def validate_type!
        self.class.check_event!(type)
      end

    end
  end
end
