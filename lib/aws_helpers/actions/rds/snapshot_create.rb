module AwsHelpers
  module Actions
    module RDS

      class SnapshotCreate

        def initialize(config, db_instance_id, use_name = false, options={})
          @config = config
          @db_instance_id = db_instance_id
          @use_name = use_name
          @options = options
        end

        def execute
          # response = AwsHelpers::Actions::RDS::SnapshotConstructName.new(@config, @db_instance_id).execute if @use_name
          # snapshot_name = "#{response || @db_instance_id}-#{@now}"
          # client = @config.aws_rds_client
          # client.create_db_snapshot(
          #   db_instance_identifier: @db_instance_id,
          #   db_snapshot_identifier: snapshot_name
          # )
          # AwsHelpers::Actions::RDS::PollDBSnapshot.new(@config, snapshot_name, @options).execute
        end

      end

    end
  end
end