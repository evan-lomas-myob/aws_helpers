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
          response = client.describe_instances(filters: filters).reservations[0].instances

          instances = []
          response.each do | instance |
            instances << instance if instance.state.name == 'running'
          end

          instances
        end

      end

    end
  end
end