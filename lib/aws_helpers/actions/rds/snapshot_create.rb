module AwsHelpers
  module Actions
    module RDS

      class SnapshotCreate

        def initialize(stdout, config, db_instance_id, use_name = false, now = Time.now.strftime('%Y-%m-%d-%H-%M'))
          @stdout = stdout
          @config = config
          @db_instance_id = db_instance_id
          @use_name = use_name
          @now = now
        end

        def execute
          response = AwsHelpers::Actions::RDS::SnapshotConstructName.new(@config, @db_instance_id).execute if @use_name
          snapshot_name = "#{response || @db_instance_id}-#{@now}"
          client = @config.aws_rds_client
          client.create_db_snapshot(
              db_instance_identifier: @db_instance_id,
              db_snapshot_identifier: snapshot_name
          )
          AwsHelpers::Actions::RDS::PollDBSnapshot.new(@stdout, @config, snapshot_name).execute
        end

      end

    end
  end
end