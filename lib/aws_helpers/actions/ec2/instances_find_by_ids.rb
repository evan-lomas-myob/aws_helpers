module AwsHelpers
  module Actions
    module EC2

      class InstancesFindByIds

        def initialize(config, ids)
          @config = config
          @ids = ids
        end

        def execute
          client = @config.aws_ec2_client
          response = client.describe_instances(instance_ids: @ids).reservations[0].instances

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