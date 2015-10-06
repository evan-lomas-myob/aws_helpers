require 'aws-sdk-core'

require 'aws_helpers/actions/elastic_load_balancing/poll_in_service_instances'

module AwsHelpers
  module Actions
    module AutoScaling

      class PollLoadBalancersInServiceInstances

        def initialize(config, auto_scaling_group_name, options = {})
          @config = config
          @auto_scaling_group_name = auto_scaling_group_name
          @options = options
        end

        def execute
          auto_scaling_client = @config.aws_auto_scaling_client
          response = auto_scaling_client.describe_load_balancers(auto_scaling_group_name: @auto_scaling_group_name)
          load_balancer_names = response.load_balancers.collect { |load_balancer| load_balancer.load_balancer_name }
          AwsHelpers::Actions::ElasticLoadBalancing::PollInServiceInstances.new(@config, load_balancer_names, @options).execute
        end

      end

    end
  end
end