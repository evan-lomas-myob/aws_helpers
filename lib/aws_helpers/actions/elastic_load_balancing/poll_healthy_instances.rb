module AwsHelpers
  module Actions
    module ElasticLoadBalancing

      class PollHealthyInstances

        def initialize(config, load_balancer_name, required_instances, timeout)
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
end