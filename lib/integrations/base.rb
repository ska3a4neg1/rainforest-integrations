require 'integrations'
require "httparty"

module Integrations
  class Base
    attr_reader :event_name, :payload, :settings

    def self.key
      raise 'key must be defined in the child class'
    end

    def initialize(event_name, payload, settings)
      validate_settings settings
      @event_name = event_name
      @payload = payload
      @settings = settings
    end

    def send_event
      raise 'send_event must be defined in the child class'
    end

    protected

    def self.required_settings
      @required_settings ||= Integration.find(key).fetch('settings').map do |setting|
        if setting['required']
          setting.fetch('key').to_sym
        end
      end.compact
    end

    def validate_settings(settings)
      self.class.required_settings.each do |setting|
        unless settings.key? setting
          raise Integrations::MisconfiguredIntegrationError, setting
        end
      end
    end
  end
end
