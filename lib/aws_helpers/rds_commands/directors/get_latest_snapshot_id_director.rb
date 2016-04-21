
require 'aws_helpers/command_runner'

module AwsHelpers
  module RDSCommands
    module Directors
      class GetLatestSnapshotIdDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def get(request)
          @request = request
          @commands = [
            AwsHelpers::RDSCommands::Commands::GetLatestSnapshotIdCommand.new(@config, request)
          ]
          execute_commands
          return @request.snapshot_id
        end
      end
    end
  end
end
