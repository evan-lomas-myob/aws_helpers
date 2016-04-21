require 'aws_helpers/rds_commands/commands/snapshots_delete_command'
require 'aws_helpers/command_runner'

module AwsHelpers
  module RDSCommands
    module Directors
      class SnapshotsDeleteDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def delete(request)
          @request = request
          @commands = [
            AwsHelpers::RDSCommands::Commands::SnapshotsDeleteCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
