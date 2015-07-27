module AwsHelpers

  module Common

    class Client

      def initialize(config = nil)
         @config = config
      end

      def configure
        yield config if block_given?
      end

      protected

      attr_reader :config

    end

  end

end
