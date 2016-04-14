require 'aws_helpers/rds_commands/commands/image_construct_name_command'
require 'aws_helpers/rds_commands/commands/image_create_command'
require 'aws_helpers/rds_commands/commands/poll_image_available_command'
require 'aws_helpers/rds_commands/commands/command_runner'

module AwsHelpers
  module RDSCommands
    module Directors
      class SnapshotDeleteDirector
        include AwsHelpers::EC2Commands::Commands::CommandRunner

        def initialize(config)
          @config = config
        end

        def create(request)
          @request = request
          @commands = [
            AwsHelpers::RDS::Commands::SnapshotDeleteCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
