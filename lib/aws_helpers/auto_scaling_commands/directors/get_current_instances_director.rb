require 'aws_helpers/auto_scaling_commands/commands/get_current_instances_command'
require 'aws_helpers/command_runner'

module AwsHelpers
  module AutoScalingCommands
    module Directors
      class GetCurrentInstancesDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def create(request)
          @request = request
          @commands = [
            AwsHelpers::AutoScalingCommands::Commands::GetCurrentInstanceCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
