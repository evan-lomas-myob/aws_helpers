require 'aws-sdk-core'

require 'aws_helpers/actions/elastic_load_balancing/poll_in_service_instances'

module AwsHelpers
  module Actions
    module AutoScaling

      class PollLoadBalancersInServiceInstances

        def initialize(std_out, config, auto_scaling_group_name, max_attempts = 15, delay = 20)
          @std_out = std_out
          @config = config
          @auto_scaling_group_name = auto_scaling_group_name
          @max_attempts = max_attempts
          @delay = delay
        end

        def execute
          auto_scaling_client = @config.aws_auto_scaling_client
          response = auto_scaling_client.describe_load_balancers(auto_scaling_group_name: @auto_scaling_group_name)
          load_balancer_names = response.load_balancers.collect{|load_balancer|load_balancer.load_balancer_name}
          AwsHelpers::Actions::ElasticLoadBalancing::PollInServiceInstances.new(@std_out, @config, load_balancer_names, @max_attempts, @delay).execute
        end

      end

    end
  end
end