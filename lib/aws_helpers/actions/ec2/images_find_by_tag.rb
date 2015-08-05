module AwsHelpers
  module Actions
    module EC2

      class ImagesFindByTag

        def initialize(config, tag)
          @config = config
          @tag = tag
        end

        def execute
          client = @config.aws_ec2_client
          client.describe_images(@tag)
        end

      end

    end
  end
end