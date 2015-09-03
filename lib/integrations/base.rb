require 'integrations'
require "httparty"

module Integrations
  class Base
    attr_reader :event_name, :payload, :settings, :run

    def self.key
      raise 'key must be defined in the child class'
    end

    def initialize(event_name, payload, settings)
      validate_settings settings
      @event_name = event_name
      @payload = payload
      @run = payload[:run] || {}
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

    protected

    def validate_settings(settings)
      self.class.required_settings.each do |setting|
        unless settings.key? setting
          raise Integrations::MisconfiguredIntegrationError, "Required setting '#{setting}' was not supplied"
        end
      end
    end

    def message_text
      message_hash = {
        'run_completion' => "Your Rainforest Run <#{payload[:frontend_url]} | Run ##{run[:id]}> #{run[:description]} #{run[:status]}. #{time_to_finish}",
        'run_error' => "Your Rainforest Run <#{payload[:frontend_url]} | Run ##{run[:id]}> #{run[:description]} errored: #{run[:error_reason]}.",
        'run_webhook_timeout' => "Your Rainforest Run <#{payload[:frontend_url]} | Run ##{run[:id]}> #{run[:description]} timed out due to your webhook failing. If you need a hand debugging it, please let us know via email at team@rainforestqa.com.",
        'run_test_failure' => "<#{payload[:frontend_url]} | Test ##{payload[:failed_test][:id]}> failed!"
      }

      message_hash[event_name]
    end

    def time_to_finish
      "Time to finish: #{humanize_secs(run[:time_to_finish])}"
    end

    def humanize_secs(seconds)
      secs = seconds.to_i
      [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map do |count, name|
        if secs > 0
          secs, n = secs.divmod(count)
          "#{n.to_i} #{name}"
        end
      end.compact.reverse.join(' ')
    end
  end
end
