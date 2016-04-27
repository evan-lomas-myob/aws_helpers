require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class GetInstanceIdByTagsCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          response = @client.describe_instances(
            filters: tag_filters)
          @request.instance_id = response.reservations.first.instances.first.instance_id unless response.reservations.empty?
        end

        def tag_filters
          @request.tags.map { |name, *values| { name: "tag:#{name}", values: values.flatten } }
        end
      end
    end
  end
end
