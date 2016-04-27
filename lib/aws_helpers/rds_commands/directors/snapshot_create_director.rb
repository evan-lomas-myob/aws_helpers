require 'aws_helpers/command_runner'

module AwsHelpers
  module RDSCommands
    module Directors
      class SnapshotCreateDirector
        include AwsHelpers::CommandRunner

        def initialize(config)
          @config = config
        end

        def create(request)
          @commands = [
            AwsHelpers::RDSCommands::Commands::PollInstanceAvailableCommand.new(@config, request),
            AwsHelpers::RDSCommands::Commands::SnapshotConstructNameCommand.new(@config, request),
            AwsHelpers::RDSCommands::Commands::SnapshotCreateCommand.new(@config, request),
            AwsHelpers::RDSCommands::Commands::PollSnapshotAvailableCommand.new(@config, request)
          ]
          execute_commands
        end
      end
    end
  end
end
