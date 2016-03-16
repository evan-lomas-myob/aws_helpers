module AwsHelpers
  module ElasticLoadBalancing
    class Instance
      def initialize(elastic_load_balancing_client, load_balancer_name)
        @elastic_load_balancing_client = elastic_load_balancing_client
        @load_balancer_name = load_balancer_name
      end

      def execute
        resp = @elastic_load_balancing_client.describe_load_balancers({load_balancer_names: [@load_balancer_name]})
        return resp.load_balancer_descriptions[0].instances
      end
    end
  end
end