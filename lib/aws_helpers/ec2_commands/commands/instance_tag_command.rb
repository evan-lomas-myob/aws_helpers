require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class InstanceTagCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          @config.aws_ec2_client.create_tags(
            resources: [@instance_id],
            tags: @request.tags
          )
        end
      end
    end
  end
end
