module AwsHelpers
  module Actions
    module RDS

      class SnapshotsDelete

        def initialize(config, db_instance_id, hours, days, months, years)
          @config = config
          @db_instance_id = db_instance_id
          @hours = hours
          @days = days
          @months = months
          @years = years
        end

        def execute

          client = @config.aws_rds_client
          snapshots = client.describe_db_snapshots(db_instance_identifier: @db_instance_id)

          delete_older_than = AwsHelpers::Utilities::SubtractTime.new(Time.now, hours: @hours, days: @days, months: @months, years: @years).execute

          snapshots.each do |snapshot|
            if snapshot.snapshot_create_time < delete_older_than
              client.delete_db_snapshot(snapshot.db_snapshot_identifier)
            end
          end

        end

      end

    end
  end
end