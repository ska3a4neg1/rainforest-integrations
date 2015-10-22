require 'yaml'

class Event
  EVENT_TYPES = YAML.load File.read(Rails.root.join('data', 'event_types.yml')).freeze

  def self.types
    EVENT_TYPES
  end
end
