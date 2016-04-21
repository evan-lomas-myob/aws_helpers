require 'aws_helpers/utilities/polling'

module AwsHelpers
  module RDSCommands
    module Commands
      class GetLatestSnapshotIdCommand < AwsHelpers::Command
        include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @rds_client = config.aws_rds_client
          @request = request
        end

        def execute
          response = @rds_client.describe_db_snapshots(db_instance_identifier: @request.db_instance_id)
          db_snapshots = response.db_snapshots
          @request.snapshot_id = db_snapshots.sort_by!(&:snapshot_create_time).last.db_snapshot_identifier
        end
      end
    end
  end
end
