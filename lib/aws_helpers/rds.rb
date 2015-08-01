require 'aws-sdk-core'
require_relative 'client'
require_relative 'config'
require_relative 'rds_actions/snapshot_create'
require_relative 'rds_actions/snapshots_delete'
require_relative 'rds_actions/snapshot_latest'

module AwsHelpers

  class RDS < AwsHelpers::Client

    # Utilities for creating, deleting and taking snapshots of RDS instances
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    def initialize(options = {})
      super(options)
    end

    # @param db_instance_id [String] Unique ID of the RDS instance
    # @param use_name [Boolean] Default: false
    def snapshot_create(db_instance_id:, use_name: false)
      AwsHelpers::RDSActions::SnapshotCreate.new(config, db_instance_id, use_name).execute
    end

    # @param db_instance_id [String] Unique ID of the RDS instance
    # @param days [Integer] Minus number of days to delete snapshots from
    # @param months [Integer] Minus number of months to delete snapshots from
    # @param years [Integer] Minus number of years to delete snapshots from
    def snapshots_delete(db_instance_id:, days: nil, months: nil, years: nil)
      AwsHelpers::RDSActions::SnapshotsDelete.new(config, db_instance_id, days, months, years).execute
    end

    # @param db_instance_id [String] Unique ID of the RDS instance
    def snapshot_latest(db_instance_id:)
      AwsHelpers::RDSActions::SnapshotLatest.new(config, db_instance_id).execute
    end

  end

end

