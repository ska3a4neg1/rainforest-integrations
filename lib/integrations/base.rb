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

    def validate_settings(settings)
      self.class.required_settings.each do |setting|
        unless settings.key? setting
          raise Integrations::MisconfiguredIntegrationError, "Required setting '#{setting}' was not supplied"
        end
      end
    end

    def message_text
      message = self.send(event_name.dup.concat("_message").to_sym)
      "Your Rainforest Run (#{run_href}) #{message}"
    end

    def run_href
      "Run ##{run[:id]}#{run_description} - #{payload[:frontend_url]}"
    end

    def test_href
      "Test ##{payload[:failed_test][:id]}: #{payload[:failed_test][:name]} - #{payload[:failed_test][:url]}"
    end

    def run_description
      run[:description] ? ": #{run[:description]}" : ""
    end

    def run_completion_message
      "#{run[:status]}. #{time_to_finish}"
    end

    def run_error_message
      "errored: #{run[:error_reason]}."
    end

    def run_webhook_timeout_message
      "has timed out due to your webhook failing. If you need a hand debugging it, please let us know via email at help@rainforestqa.com."
    end

    def run_test_failure_message
      "has a failed at test! #{test_href}"
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
