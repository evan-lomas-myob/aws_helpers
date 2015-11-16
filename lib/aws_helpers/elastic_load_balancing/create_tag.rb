module AwsHelpers
  module ElasticLoadBalancing
    class CreateTag
      def initialize(elastic_load_balancing_client, load_balancer_name, tag_key, tag_value)
        @elastic_load_balancing_client = elastic_load_balancing_client
        @load_balancer_name = load_balancer_name
        @tag_key = tag_key
        @tag_value = tag_value
      end

      def execute
        resp = @elastic_load_balancing_client.add_tags({load_balancer_names: [@load_balancer_name],
                                                        tags: [{key: @tag_key, value: @tag_value}]
                                                       })
      end
    end
  end
end
