require 'aws-sdk-core'
require_relative 'common/client'
require_relative 'config'
require_relative 'elastic_load_balancing_actions/poll_healthy_instances'

module AwsHelpers

  class ElasticLoadBalancing < AwsHelpers::Common::Client

    # Utilities for ElasticLoadBalancing maintenance
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    def initialize(options = {})
      super(AwsHelpers::Config.new(options))
    end

    # @param load_balancer_name [String] Name given to the AWS ElasticLoadBalancing instance
    # @param required_instances [Integer] The number of required instances for load balancing
    # @param timeout [Integer] Timeout in seconds before the load balancer to drop an instance
    def poll_healthy_instances(load_balancer_name:, required_instances:, timeout:)
      AwsHelpers::ElasticLoadBalancingActions::PollHealthyInstances.new(config, load_balancer_name, required_instances, timeout).execute
    end

  end

end

