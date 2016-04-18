require 'aws_helpers/ec2_commands/commands/image_add_user_command'
require 'aws_helpers/ec2_commands/commands/poll_image_available_command'
require 'aws_helpers/ec2_commands/commands/command_runner'

module AwsHelpers
  module AutoscalingCommands
    module Directors
      class GetDesiredCapacityDirector
        include AwsHelpers::EC2Commands::Commands::CommandRunner

        def initialize(config)
          @config = config
        end

        def create(request)
          @request = request
          @commands = [
            AwsHelpers::AutoscalingCommands::Commands::GetDesiredCapacityCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
