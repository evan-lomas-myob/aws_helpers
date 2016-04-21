require 'aws_helpers/command'

module AwsHelpers
  module RDSCommands
    module Commands
      class SnapshotsDeleteCommand < AwsHelpers::Command

        def initialize(config, request)
          @rds_client = config.aws_rds_client
          @request = request
          @delete_time = AwsHelpers::Utilities::DeleteTimeBuilder.new.build(@request.time_options)
          puts @delete_time
        end

        def execute
          response = @rds_client.describe_db_snapshots(db_instance_identifier: @request.db_instance_id, snapshot_type: 'manual')
          snapshots = response.db_snapshots.sort_by!(&:snapshot_create_time)
          snapshots.each do |snapshot|
            if snapshot.snapshot_create_time <= @delete_time
              @rds_client.delete_db_snapshot(db_snapshot_identifier: snapshot.db_snapshot_identifier)
              std_out.puts "Deleting Snapshot=#{snapshot.db_snapshot_identifier}, Created=#{snapshot.snapshot_create_time}"
            end
          end
        end

      end
    end
  end
end
