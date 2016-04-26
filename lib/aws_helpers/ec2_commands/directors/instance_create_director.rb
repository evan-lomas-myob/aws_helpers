require 'aws_helpers/ec2_commands/commands/image_construct_name_command'
require 'aws_helpers/ec2_commands/commands/image_create_command'
require 'aws_helpers/ec2_commands/commands/poll_instance_available_command'
require 'aws_helpers/ec2_commands/commands/instance_tag_command'
require 'aws_helpers/command_runner'

module AwsHelpers
  module EC2Commands
    module Directors
      class InstanceCreateDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def create(request)
          @request = request
          @commands = [
            AwsHelpers::EC2Commands::Commands::InstanceCreateCommand.new(@config, request),
            AwsHelpers::EC2Commands::Commands::PollInstanceAvailableCommand.new(@config, request),
            AwsHelpers::EC2Commands::Commands::InstanceTagCommand.new(@config, request),
            AwsHelpers::EC2Commands::Commands::PollInstanceHealthyCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
