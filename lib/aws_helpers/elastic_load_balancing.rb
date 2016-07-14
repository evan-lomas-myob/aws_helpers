require_relative 'client'
require_relative 'actions/elastic_load_balancing/poll_in_service_instances'
require_relative 'actions/elastic_load_balancing/create_tag'
require_relative 'actions/elastic_load_balancing/read_tag'
require_relative 'actions/elastic_load_balancing/instance'

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

    # Polls a load balancer until all instances have a status of InService or until the required_instances
    # count criteria is met
    #
    # @param load_balancer_name [String] The load balancer to poll
    # @param required_instances [String] required_instances criteria (default nil, which means it will poll until
    # all instances have a status of InService)
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout Override $stdout when logging polling output
    # @option options [Integer] :max_attempts (20) Override number of attempts
    # @option options [Integer] :delay (15) Override the delay between attempts
    #
    # @example
    #   AwsHelpers::ElasticLoadBalancing.new.poll_in_service_instances('name-elb1-LoadBala-1ABC111ABCDEF')
    #   AwsHelpers::ElasticLoadBalancing.new.poll_in_service_instances('name-elb1-LoadBala-1ABC111ABCDEF', '2')
    #
    # @return [Array<String>]
    #
    def poll_in_service_instances(load_balancer_name, required_instances = nil, options = {})
      PollInServiceInstances.new(config, [load_balancer_name], required_instances, options).execute
    end

    # Creates a tag in a load balancer
    #
    # @param load_balancer_name String The load balancer to create the tag
    # @param tag_key String The tag key to be created
    # @param tag_value String The corresponding tag value for the specified tag key
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout Override $stdout when logging polling output
    #
    # @example
    #   AwsHelpers::ElasticLoadBalancing.new.create_tag('name-elb1-LoadBala-1ABC111ABCDEF', 'green-asg', 'hulk')
    #
    # @return []
    #
    def create_tag(load_balancer_name, tag_key, tag_value, options = {})
      CreateTag.new(config, load_balancer_name, tag_key, tag_value, options).execute
    end

    # Reads a tag in a load balancer
    #
    # @param load_balancer_name String The load balancer to create the tag
    # @param tag_key String The tag key to be created
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout Override $stdout when logging polling output
    #
    # @example
    #   AwsHelpers::ElasticLoadBalancing.new.read_tag('name-elb1-LoadBala-1ABC111ABCDEF', 'green-asg')
    #
    # @return String
    #
    def read_tag(load_balancer_name, tag_key, options = {})
      ReadTag.new(config, load_balancer_name, tag_key, options).execute
    end

    # Retrieves the instances associated with a particular load balancer
    #
    # @param load_balancer_name String The load balancer to create the tag
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout Override $stdout when logging polling output
    #
    # @example
    #   AwsHelpers::ElasticLoadBalancing.new.get_instances('name-elb1-LoadBala-1ABC111ABCDEF')
    #
    # @return String
    #
    def get_instances(load_balancer_name, options = {})
      Instance.new(config, load_balancer_name, options).execute
    end
  end
end
