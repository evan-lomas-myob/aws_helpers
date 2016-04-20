require 'aws_helpers/rds_commands/commands/image_construct_name_command'
require 'aws_helpers/rds_commands/commands/image_create_command'
require 'aws_helpers/rds_commands/commands/poll_image_available_command'
require 'aws_helpers/command_runner'

module AwsHelpers
  module RDSCommands
    module Directors
      class GetLatestSnapshotIdDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def create(request)
          @request = request
          @commands = [
            AwsHelpers::RDS::Commands::GetLatestSnapshotIdCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
