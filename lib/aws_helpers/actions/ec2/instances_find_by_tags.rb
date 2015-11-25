module AwsHelpers
  module Actions
    module EC2

      class InstancesFindByTags

        def initialize(config, tags)
          @config = config
          @tags = tags
        end

        def execute
          client = @config.aws_ec2_client

          response = client.describe_instances(filters: get_tag_filters).reservations[0].instances

          instances = []
          response.each do | instance |
            instances << instance if instance.state.name == 'running'
          end

          instances
        end

        private

        def get_tag_filters
          case @tags
            when Array
              warn 'Deprecation warning: AWS::EC2#instances_find_by_tags now accepts a hash instead of an array'
              @tags.map { |tag| { name: "tag:#{tag[:name]}", values: [tag[:value]] } }
            when Hash
              @tags.map { |name, *values| { name: "tag:#{name}", values: values.flatten } }
            else
              raise ArgumentError.new('Could not parse tags')
          end
        end

      end

    end
  end
end
