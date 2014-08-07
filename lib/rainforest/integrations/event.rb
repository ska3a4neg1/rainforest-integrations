module Rainforest
  module Integrations
    class Event
      def initialize(html: , text: , is_failure: )
        @html, @text, @is_failure = html, text, is_failure
      end

      def to_html
        @html
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
        Event.new html: html, text: text, is_failure: true
      end
    end
  end
end
