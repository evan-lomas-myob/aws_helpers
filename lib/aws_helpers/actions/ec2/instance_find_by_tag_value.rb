module AwsHelpers
  module Actions
    module EC2

      class InstanceFindByTagValue

        def initialize(config, tags)
          @config = config
          @tags = tags
        end

        def execute
          client = @config.aws_ec2_client
          filters = []
          @tags.each do |tag|
            filters << {name: 'tag-value', values: [tag[:values]]}
          end

          client.describe_instances(filters: filters)
        end

      end

    end
  end
end