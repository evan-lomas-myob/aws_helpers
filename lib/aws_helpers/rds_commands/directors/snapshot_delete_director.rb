
module AwsHelpers
  module RDSCommands
    module Directors
      class SnapshotDeleteDirector
        include AwsHelpers::RDSCommands::Commands::CommandRunner

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
