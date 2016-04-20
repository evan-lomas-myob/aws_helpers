require 'aws_helpers/rds_commands/requests/snapshot_create_request'
require 'aws_helpers/rds_commands/commands/poll_instance_available_command'
require 'aws_helpers/rds_commands/commands/snapshot_construct_name_command'
require 'aws_helpers/rds_commands/commands/snapshot_create_command'
require 'aws_helpers/rds_commands/commands/poll_snapshot_available_command'
require 'aws_helpers/rds_commands/commands/command_runner'

module AwsHelpers
  module RDSCommands
    module Directors
      class SnapshotCreateDirector
        include AwsHelpers::RDSCommands::Commands::CommandRunner

        def initialize(config)
          @request = SnapshotCreateRequest.new
          @commands = [
              AwsHelpers::RDS::Commands::PollInstanceAvailableCommand.new(config, @request),
              AwsHelpers::RDS::Commands::SnapshotConstructNameCommand.new(config, @request),
              AwsHelpers::RDS::Commands::SnapshotCreateCommand.new(config, @request),
              AwsHelpers::RDS::Commands::PollSnapshotAvailableCommand.new(config, @request)
          ]

        end

        def create(db_instance_identifier, options = {})
          update_request(db_instance_identifier, options)
          execute_commands
        end

        private

        def update_request(db_instance_identifier, options)
          @request.db_instance_identifier = db_instance_identifier
          @request.stdout = options[:std_out]
          @request.use_name = options[:use_name]
          @request.instance_polling = options[:instance_polling]
          @request.snapshot_polling = options[:snapshot_polling]
        end

      end
    end
  end
end
