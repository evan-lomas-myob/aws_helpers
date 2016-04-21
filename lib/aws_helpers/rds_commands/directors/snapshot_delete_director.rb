require 'aws_helpers/rds_commands/commands/snapshot_delete_command'
require 'aws_helpers/command_runner'

module AwsHelpers
  module RDSCommands
    module Directors
      class SnapshotDeleteDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def delete(request)
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
