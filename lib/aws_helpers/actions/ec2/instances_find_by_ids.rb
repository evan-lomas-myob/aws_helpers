module AwsHelpers
  module Actions
    module EC2
      class InstancesFindByIds
        def initialize(config, ids)
          @client = config.aws_ec2_client
          @ids = ids
        end

        def execute
          response = @client.describe_instances(instance_ids: @ids).reservations.map{ |r| r.instances }.flatten
          response.select{ |instance| instance.state.name == 'running' }
        end
      end
    end
  end
end
