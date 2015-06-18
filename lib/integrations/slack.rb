require 'integrations/base'

module Integrations
  class Slack < Base
    def self.key
      'slack'
    end

    def send_event
    end
  end
end
