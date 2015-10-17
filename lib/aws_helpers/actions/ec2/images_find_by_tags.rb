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
          filters = @tags.map { |tag|
            { name: "tag:#{tag[:name]}", values: [tag[:value]] }
          }
          client.describe_images(filters: filters).images
        end

      end

    end
  end
end