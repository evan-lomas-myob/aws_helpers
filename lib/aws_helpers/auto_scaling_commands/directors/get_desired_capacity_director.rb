require 'aws_helpers/auto_scaling_commands/commands/get_desired_capacity_command'
require 'aws_helpers/command_runner'

module AwsHelpers
  module AutoScalingCommands
    module Directors
      class GetDesiredCapacityDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def get(request)
          @request = request
          @commands = [
            AwsHelpers::AutoScalingCommands::Commands::GetDesiredCapacityCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
