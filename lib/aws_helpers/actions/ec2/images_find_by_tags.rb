module AwsHelpers
  module Actions
    module EC2

      class ImagesFindByTags

        def initialize(config, tags)
          @config = config
          @tags = tags
        end

        def execute
          client = @config.aws_ec2_client
          filters = @tags.map { |tag| {name: tag[:name], values: tag[:values]} }
          client.describe_images(filters)
        end

      end

    end
  end
end