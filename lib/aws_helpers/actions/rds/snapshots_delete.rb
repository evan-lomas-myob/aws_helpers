require 'aws_helpers/utilities/delete_time_builder'

module AwsHelpers
  module Actions
    module RDS
      class SnapshotsDelete
        def initialize(config, db_instance_id, options = {})
          @config = config
          @db_instance_id = db_instance_id
          @stdout = options[:stdout] ||= $stdout
          @delete_time = AwsHelpers::Utilities::DeleteTimeBuilder.new.build(options)
        end

        def execute
          client = @config.aws_rds_client
          response = client.describe_db_snapshots(db_instance_identifier: @db_instance_id, snapshot_type: 'manual')
          snapshots = response.db_snapshots.sort_by!(&:snapshot_create_time)
          snapshots.each do |snapshot|
            if snapshot.snapshot_create_time <= @delete_time
              client.delete_db_snapshot(db_snapshot_identifier: snapshot.db_snapshot_identifier)
              @stdout.puts "Deleting Snapshot=#{snapshot.db_snapshot_identifier}, Created=#{snapshot.snapshot_create_time}"
            end
          end
        end
      end
    end
  end
end
