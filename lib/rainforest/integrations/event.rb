module Rainforest
  module Integrations
    class Event
      attr_reader :type

      TYPES = %w(
        first_failure
        run_failure
        run_success
        test_failure
        test_success
        webhook_timeout
      ).freeze

      def initialize(type: , html: , long_html: html, text: , is_failure: )
        self.class.check_event!(type)
        @type, @html, @long_html, @text, @is_failure = type, html, long_html, text, is_failure
      end

      def self.check_event!(*types)
        types.each do |type|
          unless TYPES.include?(type)
            raise ArgumentError, "Expected #{type.inspect} to be one of #{TYPES.join(", ")}"
          end

        end
      end

      def to_html(long: false)
        long ? @long_html : @html
      end

      def to_text
        @text
      end

      def failure?
        @is_failure
      end

      def self.sample_event
        html = "Your test 'My Test' just failed in chrome - <a href='http://https://app.rainforestqa.com/runs/10973/tests/4113/steps/494204/browsers/chrome'>view the failure here</a>."
        text = "Your test 'My Test' just failed in chrome"
        Event.new type: "test_failure", html: html, text: text, is_failure: true
      end
    end
  end
end
