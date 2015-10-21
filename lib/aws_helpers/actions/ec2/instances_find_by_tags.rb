module AwsHelpers
  module Actions
    module EC2

      class InstancesFindByTags

        def initialize(config, tags)
          @config = config
          @tags = tags
        end

        def execute
          client = @config.aws_ec2_client
          filters = @tags.map { |tag|
            { name: "tag:#{tag[:name]}", values: [tag[:value]] }
          }
          client.describe_instances(filters: filters).reservations[0].instances[0]
        end

      end

    end
  end
end