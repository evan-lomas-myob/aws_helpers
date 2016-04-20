require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class InstanceTerminateCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          @client.terminate_instances(
            instance_ids: [@request.instance_id]
          )
        end
      end
    end
  end
end
