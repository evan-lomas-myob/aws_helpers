require 'aws_helpers/auto_scaling_commands/commands/get_desired_capacity_command'
require 'aws_helpers/auto_scaling_commands/commands/command_runner'

module AwsHelpers
  module AutoScalingCommands
    module Directors
      class UpdateDesiredCapacityDirector
        include AwsHelpers::EC2Commands::Commands::CommandRunner

        def initialize(config)
          @config = config
        end

        def create(request)
          @request = request
          @commands = [
            AwsHelpers::AutoscalingCommands::Commands::UpdateDesiredCapacityCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
