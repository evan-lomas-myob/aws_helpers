require_relative 'client'
require_relative 'actions/elastic_load_balancing/poll_healthy_instances'

include AwsHelpers::Actions::ElasticLoadBalancing

module AwsHelpers

  class ElasticLoadBalancing < AwsHelpers::Client

    # Utilities for ElasticLoadBalancing maintenance
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    # @return [AwsHelpers::Config] A Config object with options initialized
  def initialize(options = {})
      super(options)
    end

    # @param load_balancer_name [String] Name given to the AWS ElasticLoadBalancing instance
    # @param required_instances [Integer] The number of required instances for load balancing
    # @param timeout [Integer] Timeout in seconds before the load balancer to drop an instance
    def poll_healthy_instances(load_balancer_name:, required_instances:, timeout:)
      PollHealthyInstances.new($stdout, config, load_balancer_name, required_instances, timeout).execute
    end

  end

end
