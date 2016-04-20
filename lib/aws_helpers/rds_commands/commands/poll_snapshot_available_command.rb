require 'aws_helpers/utilities/polling'
require 'aws_helpers/command'

module AwsHelpers
  module RDSCommands
    module Commands
      class PollSnapshotAvailableCommand < AwsHelpers::Command
        include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @rds_client = config.aws_rds_client
          @snapshot_name = request.snapshot_name
          @request = request
        end

        def execute
          poll(@request.snapshot_polling[:delay], @request.snapshot_polling[:max_attempts]) do
            response = @rds_client.describe_db_snapshots(db_snapshot_identifier: @snapshot_name)
            snapshot = response.db_snapshots.find { |s| s.db_snapshot_identifier == @snapshot_name }
            status = snapshot.status
            percent_progress = snapshot.percent_progress
            std_out.puts "RDS Snapshot #{@snapshot_name} #{status}, progress #{percent_progress}%"
            raise "RDS Failed to create snapshot #{@snapshot_name}" if status == 'deleting'
            status == 'available'
          end
        end

      end
    end
  end
end
