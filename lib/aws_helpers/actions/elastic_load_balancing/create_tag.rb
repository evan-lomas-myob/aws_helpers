module AwsHelpers
  module Actions
    module ElasticLoadBalancing
      class CreateTag

        def initialize(config, load_balancer_name, tag_key, tag_value, options)
          @config = config
          @load_balancer_name = load_balancer_name
          @tag_key = tag_key
          @tag_value = tag_value
          @stdout = options[:stdout] ||= $stdout

        end

        def execute
          client = @config.aws_elastic_load_balancing_client
          response = client.add_tags({load_balancer_names: [@load_balancer_name],
                                       tags: [{key: @tag_key, value: @tag_value}]
                                      })

        end
      end
    end
  end
end
