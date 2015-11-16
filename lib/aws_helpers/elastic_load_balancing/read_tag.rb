module AwsHelpers
  module ElasticLoadBalancing
    class ReadTag

      def initialize(elastic_load_balancing_client, load_balancer_name, tag_key)
        @elastic_load_balancing_client = elastic_load_balancing_client
        @load_balancer_name = load_balancer_name
        @tag_key = tag_key
      end

      def execute
        resp = @elastic_load_balancing_client.describe_tags({load_balancer_names: [@load_balancer_name]})
        if resp.tag_descriptions.length == 1
          tag =  resp.tag_descriptions[0].tags.select { |tag| tag.key == @tag_key }
          return tag[0].value if tag.length == 1
        end
        return ''
      end

    end
  end
end
