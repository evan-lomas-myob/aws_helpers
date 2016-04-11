require 'aws_helpers/ec2_commands/commands/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class InstanceCreateCommand < AwsHelpers::EC2Commands::Commands::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          @request.instance_id = @client.run_instances(
            image_id: @request.image_id,
            min_count: 1,
            max_count: 1,
          ).instances[0].instance_id
        end
      end
    end
  end
end
