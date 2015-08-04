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
          # load_balancing_client = @config.aws_elastic_load_balancing_client

          auto_scaling_client.set_desired_capacity(auto_scaling_group_name: @auto_scaling_group_name, desired_capacity: @desired_capacity)

          # auto_scaling_groups = auto_scaling_client.describe_auto_scaling_groups(@auto_scaling_group_name)
          # load_balancer_names = auto_scaling_groups.load_balancer_names
          # instances = load_balancing_client.describe_load_balancers(load_balancer_names).instances.length

          # raise('Not at capacity') unless instances != @desired_capacity

        end

      end

    end
  end
end