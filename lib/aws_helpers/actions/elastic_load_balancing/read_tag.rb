module AwsHelpers
  module Actions
    module ElasticLoadBalancing
      class ReadTag

        def initialize(config, load_balancer_name, tag_key, options)
          @config = config
          @load_balancer_name = load_balancer_name
          @tag_key = tag_key
          @stdout = options[:stdout] ||= $stdout

        end

        def execute
          client = @config.aws_elastic_load_balancing_client
          response = client.describe_tags(load_balancer_names: [@load_balancer_name])
          if response.tag_descriptions.empty?
            ''
          else
            tag = response.tag_descriptions.first.tags.select { |tag| tag.key == @tag_key }
            tag.empty? ? '' : tag.first.value
          end
        end
      end
    end
  end
end
