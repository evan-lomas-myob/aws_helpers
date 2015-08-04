module AwsHelpers
  module Actions
    module ElasticLoadBalancing

      class CheckHealthyInstances

        def initialize(config, load_balancer_name, number_of_instances)
          @config = config
          @load_balancer_name = load_balancer_name
          @number_of_instance = number_of_instances
        end

        def execute
          client = @config.aws_elastic_load_balancing_client
          load_balancer_descriptions = client.describe_load_balancers(load_balancer_names: [ @load_balancer_name ])
          instances = load_balancer_descriptions.instances.size
          raise('Not at capacity') unless instances == @number_of_instance
        end
      end
    end
  end
end