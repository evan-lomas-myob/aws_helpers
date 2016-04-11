require 'aws_helpers/ec2_commands/commands/image_construct_name_command'
require 'aws_helpers/ec2_commands/commands/image_create_command'
require 'aws_helpers/ec2_commands/commands/poll_image_available_command'
require 'aws_helpers/ec2_commands/commands/command_runner'

module AwsHelpers
  module EC2Commands
    module Directors
      class InstanceCreateDirector
        include AwsHelpers::EC2Commands::Commands::CommandRunner

        def initialize(config)
          @config = config
        end

        def create(request)
          # update_request(instance_identifier, options)
          @request = request
          @commands = [
            AwsHelpers::EC2Commands::Commands::InstanceCreateCommand.new(@config, request),
            AwsHelpers::EC2Commands::Commands::PollInstanceAvailableCommand.new(@config, request),
            AwsHelpers::EC2Commands::Commands::InstanceTagCommand.new(@config, request),
            AwsHelpers::EC2Commands::Commands::PollInstanceHealthyCommand.new(@config, request)
          ]
          execute_commands
        end

        private

        def update_request(instance_identifier, options)
          @request.instance_identifier = instance_identifier
          @request.stdout = options[:std_out]
          @request.use_name = options[:use_name]
          @request.instance_polling = options[:instance_polling]
          @request.snapshot_polling = options[:snapshot_polling]
        end
      end
    end
  end
end
