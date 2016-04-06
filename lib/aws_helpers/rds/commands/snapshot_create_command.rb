require 'aws_helpers/rds/commands/command'

module AwsHelpers
  module RDS
    module Commands
      class SnapshotCreateCommand < AwsHelpers::RDS::Commands::Command

        def initialize(config, request)
          @rds_client = config.aws_rds_client
          @db_instance_identifier = request.db_instance_identifier
          @snapshot_name = request.snapshot_name
        end

        def execute
          @rds_client.create_db_snapshot(
              db_instance_identifier: @db_instance_identifier,
              db_snapshot_identifier: @snapshot_name
          )
        end

      end
    end
  end
end
