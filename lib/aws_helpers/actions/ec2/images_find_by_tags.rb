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

          filters = @tags.each do |tag|
            {name: tag[:name], value: [tag[:value]]}
          end

          client.describe_images(filters)

        end

      end

    end
  end
end