require 'yaml'

class Event
  EVENTS = YAML.load File.read(Rails.root.join('data', 'events.yml')).freeze

  def self.all
    EVENTS
  end
end
