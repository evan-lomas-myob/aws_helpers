require 'aws_helpers/actions/auto_scaling/poll_in_service_instances'
require 'aws_helpers/actions/auto_scaling/poll_load_balancers_in_service_instances'
require 'aws_helpers/utilities/polling_options'


module AwsHelpers
  module Actions
    module AutoScaling
      class UpdateDesiredCapacity
        include AwsHelpers::Utilities::PollingOptions

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

      end
    end
  end
end
