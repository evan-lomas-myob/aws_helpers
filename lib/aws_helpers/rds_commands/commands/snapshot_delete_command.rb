require 'aws_helpers/command'

module AwsHelpers
  module RDSCommands
    module Commands
      class SnapshotDeleteCommand < AwsHelpers::Command

        def initialize(config, request)
          @rds_client = config.aws_rds_client
          @request = request
        end

        def execute
          # @request.snapshot_id = @rds_client.create_db_snapshot(
          #     db_instance_identifier: @request.db_instance_identifier,
          #     db_snapshot_identifier: @request.snapshot_name
          # ).db_snapshot.db_snapshot_identifier
        end

      end
    end
  end
end
