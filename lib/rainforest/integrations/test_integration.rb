module Rainforest
  module Integrations
    class TestIntegration < Base
      include HttpIntegration

      Result = Struct.new(:event, :config)

      # Noop, but return the args as something we can inspect in tests
      def on_event(event)
        Result.new(event, config)
      end
    end
  end
end


