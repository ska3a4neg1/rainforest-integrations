require "ostruct"
require "rainforest/integrations/version"
require "rainforest/integrations/base"
require "rainforest/integrations/event"
require "rainforest/integrations/http_integration"

require "rainforest/integrations/hipchat"

module Rainforest
  module Integrations
    # Your code goes here...
    def self.send_event(integration, event: , config: )
      integration = self.const_get(integration.capitalize).new(config)
      integration.on_event(Event.new(event))
    end
  end
end
