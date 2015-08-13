require 'aws_helpers/actions/auto_scaling/poll_in_service_instances'
require 'aws_helpers/actions/auto_scaling/poll_load_balancers_in_service_instances'

module AwsHelpers
  module Actions
    module AutoScaling

      class UpdateDesiredCapacity

        def initialize(config, auto_scaling_group_name, desired_capacity)
          @config = config
          @auto_scaling_group_name = auto_scaling_group_name
          @desired_capacity = desired_capacity
        end

        def execute
          auto_scaling_client = @config.aws_auto_scaling_client
          auto_scaling_client.set_desired_capacity(auto_scaling_group_name: @auto_scaling_group_name, desired_capacity: @desired_capacity)
          AwsHelpers::Actions::AutoScaling::PollInServiceInstances.new($stdout, @config, @auto_scaling_group_name).execute
          AwsHelpers::Actions::AutoScaling::PollLoadBalancersInServiceInstances.new($stdout, @config, @auto_scaling_group_name).execute
        end

      end

    end
  end
end