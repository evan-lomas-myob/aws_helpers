
module AwsHelpers
  module RDSCommands
    module Directors
      class GetLatestSnapshotIdDirector
        include AwsHelpers::RDSCommands::Commands::CommandRunner

        def initialize(config)
          @config = config
        end

        def get(request)
          @request = request
          @commands = [
            AwsHelpers::RDS::Commands::GetLatestSnapshotIdCommand.new(@config, request)
          ]
          execute_commands
          return @request.snapshot_id
        end
      end
    end
  end
end
