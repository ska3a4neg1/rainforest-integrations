require 'yaml'

class Integration
  INTEGRATIONS = YAML.load File.read(Rails.root.join('data', 'integrations.yml')).freeze

  class NotFound < StandardError
  end

  def self.find key
    data = INTEGRATIONS.fetch(key) do
      raise NotFound, %(Integration "#{key}" is not supported)
    end

    { 'key' => key }.merge data
  end

  def self.exists? key
    INTEGRATIONS.key? key
  end

  def self.supported_integrations
    INTEGRATIONS.keys.freeze
  end

  def self.all
    INTEGRATIONS.map do |key, data|
      { 'key' => key }.merge data
    end
  end
end
