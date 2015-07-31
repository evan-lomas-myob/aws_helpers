module AwsHelpers

  module ElasticLoadBalancing

    class PollHealthyInstances

      def initialize(config, load_balancer_name, required_instances, timeout)

        # @param config [AwsHelpers::ElasticLoadBalancing::Config] access class for Aws::ElasticLoadBalancing::Client
        # @param load_balancer_name [String] Name given to the AWS ElasticLoadBalancing instance
        # @param required_instances [Integer] The number of required instances for load balancing
        # @param timeout [Integer] Timeout in seconds before the load balancer to drop an instance

        @config = config
        @load_balancer_name = load_balancer_name
        @required_instances = required_instances
        @timeout = timeout

      end

      def execute

      end
    end
  end
end