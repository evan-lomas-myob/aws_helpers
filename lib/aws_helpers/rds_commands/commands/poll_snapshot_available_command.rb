require 'aws_helpers/actions/rds/snapshot_status'
require 'aws_helpers/utilities/polling'
require 'aws_helpers/rds_commands/commands/command'

module AwsHelpers
  module RDSCommands
    module Commands
      class PollSnapshotAvailableCommand < AwsHelpers::RDSCommands::Commands::Command
        include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @rds_client = config.aws_rds_client
          @snapshot_name = request.snapshot_name
          @std_out = request.std_out
          @max_attempts = request.snapshot_polling[:max_attempts] || 60
          @delay = request.snapshot_polling[:delay] || 30
        end

        def execute
          poll(@delay, @max_attempts) do
            response = @rds_client.describe_db_snapshots(db_snapshot_identifier: @snapshot_name)
            snapshot = response.db_snapshots.find { |s| s.db_snapshot_identifier == @snapshot_name }
            status = snapshot.status
            percent_progress = snapshot.percent_progress
            stdout.puts "RDS Snapshot #{@snapshot_name} #{status}, progress #{percent_progress}%"
            raise "RDS Failed to create snapshot #{@snapshot_name}" if status == SnapshotStatus::DELETING
            status == SnapshotStatus::AVAILABLE
          end
        end

      end
    end
  end
end
