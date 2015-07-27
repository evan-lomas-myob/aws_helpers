module AwsHelpers

  module Common

    class Config

      attr_reader :options

      def initialize(options)
        @options = {retry_limit: 5}.merge(options)
      end

    end
  end
end