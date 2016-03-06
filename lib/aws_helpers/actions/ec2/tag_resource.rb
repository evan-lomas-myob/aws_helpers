module AwsHelpers
  module Actions
    module EC2

      class TagResource

        def initialize(config, resource_id, tags)
          @client = config.aws_ec2_client
          @resource_id = resource_id
          @tags = tags
        end

        def execute
          @client.create_tags(
            resources: [@resource_id],
            tags: @tags)
        end

      end

    end
  end
end