module AwsHelpers
  module Actions
    module RDS

      class SnapshotLatest

        def initialize(config, db_instance_id)
          @config = config
          @db_instance_id = db_instance_id
        end

        def execute
          client = @config.aws_rds_client
          db_snapshots = client.describe_db_snapshots(db_instance_identifier: @db_instance_id)
          db_snapshots.sort_by! { |db_snapshot| db_snapshot.snapshot_create_time }.last.db_snapshot_identifier
        end

      end

    end
  end
end