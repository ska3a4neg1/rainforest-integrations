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
    end
  end
end
