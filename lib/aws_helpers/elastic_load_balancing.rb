require_relative 'client'
require_relative 'actions/elastic_load_balancing/poll_in_service_instances'

include AwsHelpers::Actions::ElasticLoadBalancing

module AwsHelpers

  class ElasticLoadBalancing < AwsHelpers::Client

    # Utilities for ElasticLoadBalancing maintenance
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    def initialize(options = {})
      super(options)
    end

    # Polls a load balancer until all instances have a status of InService
    # @param load_balancer_name [String] The load balancer to poll
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout Override $stdout when logging polling output
    # @option options [Integer] :max_attempts (20) Override number of attempts
    # @option options [Integer] :delay (15) Override the delay between attempts
    def poll_in_service_instances(load_balancer_name, options= {})
      PollInServiceInstances.new(config, [load_balancer_name], options).execute
    end

  end

end

