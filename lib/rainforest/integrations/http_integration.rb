module Rainforest
  module Integrations
    module HttpIntegration
      def post(*args)
        HTTParty.post *args
      end
    end
  end
end

