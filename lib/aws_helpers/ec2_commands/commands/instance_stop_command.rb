require 'aws_helpers/ec2_commands/commands/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class InstanceStopCommand < AwsHelpers::EC2Commands::Commands::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          @client.stop_instances(
            instance_ids: @request.instance_ids
          )
        end
      end
    end
  end
end
