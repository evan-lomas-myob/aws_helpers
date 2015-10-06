require 'aws_helpers/utilities/delete_time_builder'

module AwsHelpers
  module Actions
    module RDS

      class SnapshotsDelete

        def initialize(config, db_instance_id, options = {})
          @config = config
          @db_instance_id = db_instance_id
          @stdout = options[:stdout] || $stdout
          @delete_time = AwsHelpers::Utilities::DeleteTimeBuilder.new.build(options)
        end

        def execute
          client = @config.aws_rds_client
          response = client.describe_db_snapshots(db_instance_identifier: @db_instance_id, snapshot_type: 'manual')
          snapshots = response.db_snapshots
          snapshots.sort_by! { |snapshot| snapshot.snapshot_create_time }
          snapshots.each do |snapshot|
            create_time = snapshot.snapshot_create_time
            identifier = snapshot.db_snapshot_identifier
            if create_time <= @delete_time
              client.delete_db_snapshot(db_snapshot_identifier: identifier)
              @stdout.puts "Deleting Snapshot=#{identifier}, Created=#{create_time}"
            end
          end

        end

      end

    end
  end
end