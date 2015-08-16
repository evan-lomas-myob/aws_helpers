require 'aws_helpers/actions/rds/snapshot_status'
require 'aws_helpers/utilities/polling'

module AwsHelpers
  module Actions
    module RDS

      class PollSnapshotAvailable

        def initialize(config, snapshot_id, options={})
          @config = config
          @snapshot_id = snapshot_id
          @stdout = options[:stdout] ||= $stdout
          @max_attempts = options[:max_attempts] ||= 60
          @delay = options[:delay] || 30
        end

        def execute
          client = @config.aws_rds_client
          pooling = AwsHelpers::Utilities::Polling.new
          pooling.start(@delay,@max_attempts){
            response = client.describe_db_snapshots(db_snapshot_identifier: @snapshot_id)
            snapshot = response.db_snapshots.find{|snapshot| snapshot.db_snapshot_identifier == @snapshot_id}
            status = snapshot.status
            percent_progress = snapshot.percent_progress
            @stdout.puts "Snapshot #{@snapshot_id} #{status}, progress #{percent_progress}%"
            raise "Failed to create snapshot #{@snapshot_id}" if status == SnapshotStatus::DELETING
            pooling.stop if status == SnapshotStatus::AVAILABLE
          }
        end

      end

    end
  end
end