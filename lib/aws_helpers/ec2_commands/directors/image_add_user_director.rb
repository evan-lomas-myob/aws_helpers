require 'aws_helpers/ec2_commands/commands/image_add_user_command'
require 'aws_helpers/ec2_commands/commands/poll_image_available_command'
require 'aws_helpers/command_runner'

module AwsHelpers
  module EC2Commands
    module Directors
      class ImageAddUserDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def create(request)
          @request = request
          @commands = [
            AwsHelpers::EC2Commands::Commands::PollImageAvailableCommand.new(@config, request),
            AwsHelpers::EC2Commands::Commands::ImageAddUserCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
