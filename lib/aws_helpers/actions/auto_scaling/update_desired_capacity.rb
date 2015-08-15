require 'aws_helpers/actions/auto_scaling/poll_in_service_instances'
require 'aws_helpers/actions/auto_scaling/poll_load_balancers_in_service_instances'

module AwsHelpers
  module Actions
    module AutoScaling

      class UpdateDesiredCapacity

        def initialize(config, auto_scaling_group_name, desired_capacity, options = {})
          @config = config
          @auto_scaling_group_name = auto_scaling_group_name
          @desired_capacity = desired_capacity
          stdout = options[:stdout]
          @poll_in_service_instances_options = create_options(stdout, options[:auto_scaling_polling])
          @poll_load_balancers_in_service_instances_options = create_options(stdout, options[:load_balancer_polling])
        end

        def execute
          auto_scaling_client = @config.aws_auto_scaling_client
          auto_scaling_client.set_desired_capacity(auto_scaling_group_name: @auto_scaling_group_name, desired_capacity: @desired_capacity)
          AwsHelpers::Actions::AutoScaling::PollInServiceInstances.new(@config, @auto_scaling_group_name, @poll_in_service_instances_options).execute
          AwsHelpers::Actions::AutoScaling::PollLoadBalancersInServiceInstances.new(@config, @auto_scaling_group_name, @poll_load_balancers_in_service_instances_options).execute
        end

        private

        def create_options(stdout, pooling)
          options = {}
          options[:stdout] = stdout if stdout
          if pooling
            max_attempts = pooling[:max_attempts]
            delay = pooling[:delay]
            options[:max_attempts] = max_attempts if max_attempts
            options[:delay] = delay if delay
          end
          options
        end

      end

    end
  end
end