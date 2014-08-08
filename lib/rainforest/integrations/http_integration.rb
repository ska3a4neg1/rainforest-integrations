module Rainforest
  module Integrations
    module HttpIntegration
      def post(*args)
        Http::Exceptions.wrap_and_check do
          HTTParty.post *args
        end
      end
    end
  end
end

