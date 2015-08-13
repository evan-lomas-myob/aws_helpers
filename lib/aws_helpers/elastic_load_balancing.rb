require_relative 'client'
require_relative 'actions/elastic_load_balancing/poll_in_service_instances'

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
    def poll_in_service_instances(load_balancer_name:)
      PollInServiceInstances.new($stdout, config, [load_balancer_name]).execute
    end

  end

end

