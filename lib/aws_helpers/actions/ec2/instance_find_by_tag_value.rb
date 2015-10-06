module AwsHelpers
  module Actions
    module EC2

      class InstanceFindByTagValue

        def initialize(config, tag_values)
          @config = config
          @tag_values = tag_values
        end

        def execute
          client = @config.aws_ec2_client
          filters = []
          @tag_values.each do |value|
            filters << {name: 'tag-value', values: [ value ]}
          end

          client.describe_instances(filters: filters)
        end

      end

    end
  end
end