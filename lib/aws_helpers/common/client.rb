require_relative 'config'

module AwsHelpers

  module Common

    class Client

      attr_reader :config

      def initialize(config = nil)
         @config = config
      end

      def configure
        yield config if block_given?
      end

    end

  end

end
