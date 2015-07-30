module AwsHelpers

  module EC2

    class ImagesDeleteByTime

      # @param [aws_ec2_client] config

      def initialize(config, name, time)

        @config = config
        @name = name
        @time = time

      end

      def execute

      end
    end

  end

end