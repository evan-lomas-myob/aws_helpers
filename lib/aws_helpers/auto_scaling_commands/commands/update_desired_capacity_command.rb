require 'aws_helpers/auto_scaling_commands/commands/command'

module AwsHelpers
  module AutoScalingCommands
    module Commands
      class UpdateDesiredCapacityCommand < AwsHelpers::AutoScalingCommands::Commands::Command
        def initialize(config, request)
          @client = config.aws_auto_scaling_client
          @request = request
        end

        def execute
          @client.set_desired_capacity(
            auto_scaling_group_name: @request.auto_scaling_group_name,
            desired_capacity: @request.desired_capacity
          )
        end
      end
    end
  end
end
