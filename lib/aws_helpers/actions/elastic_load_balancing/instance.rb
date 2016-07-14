module AwsHelpers
  module Actions
    module ElasticLoadBalancing
      class Instance

        def initialize(config, load_balancer_name, options)
          @config = config
          @load_balancer_name = load_balancer_name
          @stdout = options[:stdout] ||= $stdout

        end

        def execute
          client = @config.aws_elastic_load_balancing_client
          response = client.describe_load_balancers({load_balancer_names: [@load_balancer_name]})
          if response.load_balancer_descriptions.empty?
            []
          else
            response.load_balancer_descriptions.first.instances
          end
        end
      end
    end
  end
end
