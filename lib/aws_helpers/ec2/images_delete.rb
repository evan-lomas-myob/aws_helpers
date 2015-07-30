module AwsHelpers

  module EC2

    class ImagesDelete

      # @param [aws_ec2_client] config

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