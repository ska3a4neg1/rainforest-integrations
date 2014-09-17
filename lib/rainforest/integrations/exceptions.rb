module Rainforest::Integrations

  class Error < StandardError; end

  class ConfigurationError < Error
    attr_reader :original_exception

    def initialize(msg, original_exception: nil)
      @original_exception = original_exception
      super(msg)
    end
  end
end

