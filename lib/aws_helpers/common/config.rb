module AwsHelpers

  module Common

    class Config

      # Common Options Config attribute access reader

      # @param options [Hash] Optional parameters to pass to AWS SDK
      # @return [Hash] The options to be passed to AWS SDK

      attr_reader :options

      def initialize(options)
        @options = {retry_limit: 5}.merge(options)
      end

    end
  end
end