module AwsHelpers

  module EC2

    class ImagesFindByTags

      # @param [aws_ec2_client] config

      def initialize(config, tags)

        @config = config
        @tags = tags

      end

      def execute

      end
    end

  end

end