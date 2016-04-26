require 'aws_helpers/auto_scaling_commands/commands/get_desired_capacity_command'
require 'aws_helpers/command_runner'

module AwsHelpers
  module AutoScalingCommands
    module Directors
      class UpdateDesiredCapacityDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def update(request)
          @request = request
          @commands = [
            AwsHelpers::AutoScalingCommands::Commands::UpdateDesiredCapacityCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
