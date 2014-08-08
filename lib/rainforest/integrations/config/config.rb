module Rainforest
  module Integrations
    module Config
      class Config
        attr_reader :variables

        def initialize(&block)
          @variables = []
          instance_eval &block if block_given?
          freeze
          @variables.freeze
        end

        def string(name)
          @variables << name
        end

        def valid?(attributes)
          @variables.all? {|v| attributes.has_key?(v) }
        end
      end
    end
  end
end

