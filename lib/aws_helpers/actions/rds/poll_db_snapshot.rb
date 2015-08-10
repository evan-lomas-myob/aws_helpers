module AwsHelpers
  module Actions
    module RDS

      class PollDBSnapshot

        CREATING = 'creating'
        AVAILABLE = 'available'
        DELETING = 'deleting'
        UNKNOWN = 'unknown'

        def initialize(stdout, config, db_snapshot_id, sleep_time)
          @stdout = stdout
          @config = config
          @db_snapshot_id = db_snapshot_id
          @sleep_time = sleep_time
        end

        def execute
          client = @config.aws_rds_client

          begin
            response = client.describe_db_snapshots(db_snapshot_identifier: @db_snapshot_id).first
            raise "Failed to create snapshot #{@db_snapshot_id}" if response.status == DELETING
            @stdout.puts "Snapshot #{@db_snapshot_id} #{response.status}, progress #{response.percent_progress}%"
            sleep @sleep_time
          end while response.status != AVAILABLE

          @stdout.puts "Snapshot #{@db_snapshot_id} creation completed"

        end

      end

    end
  end
end