require_relative 'client'
require_relative 'actions/rds/snapshot_create'
require_relative 'actions/rds/snapshots_delete'
require_relative 'actions/rds/latest_snapshot'

include AwsHelpers
include AwsHelpers::Actions::RDS

module AwsHelpers

  class RDS < AwsHelpers::Client

    # Utilities for creating, deleting and taking snapshots of RDS instances
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    # @return [AwsHelpers::Config] A Config object with options initialized
    def initialize(options = {})
      super(options)
    end

    # @param db_instance_id [String] Unique ID of the RDS instance
    # @param use_name [Boolean] Default: false
    def snapshot_create(db_instance_id, use_name = false)
      SnapshotCreate.new(config, db_instance_id, use_name).execute
    end

    # @param db_instance_id [String] Unique ID of the RDS instance
    def snapshots_delete(db_instance_id, options = {} )
      SnapshotsDelete.new(config, db_instance_id, options).execute
    end

    # @param db_instance_id [String] the instance id
    # @return [String] The latest snapshot id for the instance
    def latest_snapshot(db_instance_id)
      LatestSnapshot.new(config, db_instance_id).execute
    end

  end

end

