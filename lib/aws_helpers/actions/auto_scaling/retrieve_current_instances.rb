module AwsHelpers
  module Actions
    module AutoScaling
      class RetrieveCurrentInstances
        def initialize(config, auto_scaling_group_name)
          @config = config
          @auto_scaling_group_name = auto_scaling_group_name
        end

        def execute
          client = @config.aws_auto_scaling_client
          response = client.describe_auto_scaling_groups(auto_scaling_group_names: [@auto_scaling_group_name])
          if response[0][0].nil?
            []
          else
            instance_ids = response[0][0].instances.map(&:instance_id)
            @config.aws_ec2_client.describe_instances(instance_ids: instance_ids).reservations.map{ |r| r.instances }.flatten
          end
        end
      end
    end
  end
end
