require 'aws_helpers/utilities/polling'
require 'aws_helpers/command'

module AwsHelpers
  module RDSCommands
    module Commands
      class PollSnapshotAvailableCommand < AwsHelpers::Command
        include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @rds_client = config.aws_rds_client
          # @request.snapshot_name = request.snapshot_name
          @request = request
        end

        def execute
          poll(@request.snapshot_polling[:delay], @request.snapshot_polling[:max_attempts]) do
            response = @rds_client.describe_db_snapshots(db_instance_identifier: @request.db_instance_id)
            puts reponse.db_snapshots
            snapshot = response.db_snapshots.find { |s| s.db_snapshot_identifier == @request.snapshot_name }
            status = snapshot.status
            percent_progress = snapshot.percent_progress
            std_out.puts "RDS Snapshot #{@request.snapshot_name} #{status}, progress #{percent_progress}%"
            raise "RDS Failed to create snapshot #{@request.snapshot_name}" if status == 'deleting'
            status == 'available'
          end
        end

      end
    end
  end
end
