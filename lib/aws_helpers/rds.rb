require_relative 'client'
require_relative 'actions/rds/snapshot_create'
require_relative 'actions/rds/snapshots_delete'
require_relative 'actions/rds/latest_snapshot'

include AwsHelpers
include AwsHelpers::Actions::RDS

module AwsHelpers

  class RDS < AwsHelpers::Client

    # Utilities for manipulating RDS instances
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    # @return [AwsHelpers::Config] A Config object with options initialized
    def initialize(options = {})
      super(options)
    end

    # Creates a manual snapshot of an RDS instance
    # @param db_instance_id [String] The RDS instance id
    # @param use_name [Boolean] (false) Add the Name tag to the snapshot identifier to make it easier to read
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout Override $stdout when logging pooling output
    # @option options [Integer] :max_attempts (60) Override number of attempts
    # @option options [Integer] :delay (30) Override the delay between attempts
    def snapshot_create(db_instance_id, use_name = false, options ={})
      SnapshotCreate.new(config, db_instance_id, use_name, options).execute
    end

    # Deletes manual snapshots that were made for the RDS instance from now. Optionally keep snapshots for hours, days, months and years
    # @param db_instance_id [String] Unique ID of the RDS instance
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [Integer] :hours Hours to keep snapshots
    # @option options [Integer] :days Days to keep snapshots
    # @option options [Integer] :months Months to keep snapshots
    # @option options [Integer] :years Years to keep snapshots
    def snapshots_delete(db_instance_id, options = {})
      SnapshotsDelete.new(config, db_instance_id, options).execute
    end

    # Gets the latest snapshot that was made for the RDS instance
    # @param db_instance_id [String] The RDS instance id
    # @return [String] The latest snapshot id for the instance
    def latest_snapshot(db_instance_id)
      LatestSnapshot.new(config, db_instance_id).execute
    end

  end

end

