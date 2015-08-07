module AwsHelpers
  module Actions
    module RDS

      class SnapshotCreate

        def initialize(config, db_instance_id, use_name = false, now = Time.now.strftime('%Y-%m-%d-%H-%M'))
          @config = config
          @db_instance_id = db_instance_id
          @use_name = use_name
          @now = now
        end

        def execute
          snapshot_name = AwsHelpers::Actions::RDS::SnapshotConstructName.new(@config, @db_instance_id).execute if @use_name

          client = @config.aws_rds_client
          snapshot = client.create_db_snapshot(
              db_instance_identifier: @db_instance_id,
              db_snapshot_identifier: snapshot_name ? snapshot_name : "#{@db_instance_id}-#{@now}"
          )
          # puts snapshot
        end


      end

    end
  end
end