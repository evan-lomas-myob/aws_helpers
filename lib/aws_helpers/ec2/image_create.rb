module AwsHelpers

  module EC2

    class ImageCreate

      # @param [aws_ec2_client] config

      def initialize(config, instance_id, name, additional_tags)

        @config = config
        @instance_id = instance_id
        @name = name
        @additional_tags = additional_tags

      end

      def execute

      end

    end

  end

end