require_relative 'config'

module AwsHelpers

  module Common

    class Client

      # Common Client config attribute access reader
      # @param config [Hash] Optional config
      # @return [Hash]
      attr_reader :config

      def initialize(config = nil)
         @config = config
      end

      # @return [Hash]

      def configure
        yield config if block_given?
      end

    end

  end

end
