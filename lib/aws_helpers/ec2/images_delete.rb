module AwsHelpers

  module EC2

    class ImagesDelete

      # Delete AWS EC2 instance

      # @param config [AwsHelpers::EC2::Config] Class to access Aws::EC2::Client object
      # @param name [String] Name given to the AWS EC2 instance
      # @param options [Hash] Optional options to pass to the AWS SDK

      def initialize(config, name, options)

        @config = config
        @name = name
        @options = options

      end

      def execute

      end
    end

  end

end