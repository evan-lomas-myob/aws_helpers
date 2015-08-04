require 'aws_helpers/actions/elastic_load_balancing/check_healthy_instances'

module AwsHelpers
  module Actions
    module AutoScaling

      class UpdateDesiredCapacity

        def initialize(config, auto_scaling_group_name, desired_capacity, timeout)
          @config = config
          @auto_scaling_group_name = auto_scaling_group_name
          @desired_capacity = desired_capacity
          @timeout = timeout
        end

        def execute
          auto_scaling_client = @config.aws_auto_scaling_client
          auto_scaling_client.set_desired_capacity(auto_scaling_group_name: @auto_scaling_group_name, desired_capacity: @desired_capacity)

          auto_scaling_groups = auto_scaling_client.describe_auto_scaling_groups(auto_scaling_group_name: @auto_scaling_group_name)
          load_balancer_names = auto_scaling_groups.load_balancer_names

          load_balancer_names.each do | load_balancer_name |
            AwsHelpers::Actions::ElasticLoadBalancing::CheckHealthyInstances.new(@config, load_balancer_name, @desired_capacity).execute
          end

        end

      end

    end
  end
end