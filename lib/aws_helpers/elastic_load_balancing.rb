require_relative 'client'
require_relative 'elb_commands/requests/poll_in_service_instances_request'
require_relative 'elb_commands/directors/poll_in_service_instances_director'

include AwsHelpers::ELBCommands::Directors
include AwsHelpers::ELBCommands::Requests

include AwsHelpers::Actions::ElasticLoadBalancing

module AwsHelpers
  class ElasticLoadBalancing < AwsHelpers::Client
    # Utilities for ElasticLoadBalancing maintenance
    #
    # @param options [Hash] Optional arguments to include when calling the AWS SDK. These arguments will
    #   affect all clients used by this helper. See the {http://docs.aws.amazon.com/sdkforruby/api/Aws/ElasticLoadBalancing/Client.html#initialize-instance_method AWS documentation}
    #   for a list of ELB client options.
    #
    # @example Initialise ElasticLoadBalancing Client
    #    client = AwsHelpers::ElasticLoadBalancing.new
    #
    # @return [AwsHelpers::ElasticLoadBalancing]
    #
    def initialize(options = {})
      super(options)
    end

    # Polls a load balancer until all instances have a status of InService
    #
    # @param load_balancer_name [String] The load balancer to poll
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout Override $stdout when logging polling output
    # @option options [Integer] :max_attempts (20) Override number of attempts
    # @option options [Integer] :delay (15) Override the delay between attempts
    #
    # @example
    #   AwsHelpers::ElasticLoadBalancing.new.poll_in_service_instances('name-elb1-LoadBala-1ABC111ABCDEF')
    #
    # @return [Array<String>]
    #
    def poll_in_service_instances(load_balancer_name)
      request = PollInServiceInstancesRequest.new(load_balancer_name: load_balancer_name)
      PollInServiceInstancesDirector.new(config).execute(request)
    end
  end
end
