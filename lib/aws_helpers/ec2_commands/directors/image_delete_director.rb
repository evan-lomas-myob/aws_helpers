require 'aws_helpers/ec2_commands/commands/image_construct_name_command'
require 'aws_helpers/ec2_commands/commands/image_create_command'
require 'aws_helpers/ec2_commands/commands/poll_image_available_command'
require 'aws_helpers/command_runner'

module AwsHelpers
  module EC2Commands
    module Directors
      class ImageDeleteDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def create(request)
          @request = request
          @commands = [
            AwsHelpers::EC2Commands::Commands::ImageDeleteCommand.new(@config, request),
            AwsHelpers::EC2Commands::Commands::PollImageDeletedCommand.new(@config, request),
            AwsHelpers::EC2Commands::Commands::SnapshotsDeleteCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
