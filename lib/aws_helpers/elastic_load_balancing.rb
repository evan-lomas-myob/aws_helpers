require_relative 'client'
Dir.glob(File.join(File.dirname(__FILE__), 'elb_commands/**/*.rb'), &method(:require))

include AwsHelpers::ELBCommands::Directors
include AwsHelpers::ELBCommands::Requests

# include AwsHelpers::Actions::ElasticLoadBalancing

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
    # @option options [Hash] :poll_image_available override image available polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 20,
    #     :delay => 30 # seconds
    #   }
    #   ```
    #
    # @example
    #   AwsHelpers::ElasticLoadBalancing.new.poll_in_service_instances('name-elb1-LoadBala-1ABC111ABCDEF')
    #
    # @return [Array<String>]
    #
    def poll_in_service_instances(load_balancer_name, options = {})
      request = PollInServiceInstancesRequest.new
      request.load_balancer_name = load_balancer_name
      request.instance_polling = options[:instance_polling] if options[:instance_polling]
      PollInServiceInstancesDirector.new(config).execute(request)
    end
  end
end
