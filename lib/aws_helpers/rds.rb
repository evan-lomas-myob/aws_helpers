require_relative 'client'

Dir.glob(File.join(File.dirname(__FILE__), 'rds_commands/**/*.rb'), &method(:require))

include AwsHelpers::RDSCommands::Directors
include AwsHelpers::RDSCommands::Requests
# include AwsHelpers::Actions::RDS

module AwsHelpers
  class RDS < AwsHelpers::Client
    # Utilities for manipulating RDS instances
    #
    # @param options [Hash] Optional arguments to include when calling the AWS SDK. These arguments will
    #   affect all clients used by this helper. See the {http://docs.aws.amazon.com/sdkforruby/api/Aws/RDS/Client.html#initialize-instance_method AWS documentation}
    #   for a list of RDS client options.
    #
    # @example Create a RDS Client
    #   AwsHelpers.RDS.new
    # @example Create a RDS Client with a custom retry limit
    #   AwsHelpers.RDS.new(retry_limit: 8)
    #
    # @return [AwsHelpers::RDS]
    #
    def initialize(options = {})
      super(options)
    end

    # Creates a manual snapshot of an RDS instance
    #
    # - Before creating the snapshot will poll the instance until it is available.
    # - After the snapshot is created will poll until the snapshot is available
    # @param db_instance_id [String] The RDS instance id
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [Boolean] :use_name (false) Set to true to make the snapshot name start with the value of tag who's key is Name on the database instance
    # @option options [Hash{Symbol => Integer}] :instance_polling Override instance default polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 60,
    #     :delay => 30 # seconds
    #   }
    #   ```
    # @option options [Hash{Symbol => Integer}] :snapshot_polling Override snapshot default polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 60,
    #     :delay => 30 # seconds
    #   }
    #   ```
    #
    # @example Create a new RDS snapshot
    #   AwsHelpers::RDS.new.snapshot_create('DBName')
    #
    # @return [nil]
    #

    def snapshot_create(db_instance_id, options = {})
      request = SnapshotCreateRequest.new
      request.db_instance_id = db_instance_id
      request.use_name = options[:use_name] if options[:use_name]
      request.snapshot_polling = options[:snapshot_polling] if options[:snapshot_polling]
      request.instance_polling = options[:instance_polling] if options[:instance_polling]
      SnapshotCreateDirector.new(config).create(request)
      request.snapshot_id
    end

    # Deletes manual snapshots that were made for the RDS instance from now. Optionally keep snapshots for hours, days, months and years
    #
    # @param db_instance_id [String] Unique ID of the RDS instance
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [Integer] :hours Hours to keep snapshots
    # @option options [Integer] :days Days to keep snapshots
    # @option options [Integer] :months Months to keep snapshots
    # @option options [Integer] :years Years to keep snapshots
    #
    # @example Remove a manual snapshot
    #   AwsHelpers::RDS.new.snapshots_delete('DBName')
    #
    # @return [struct Aws::RDS::Types::DBSnapshot]

    def snapshots_delete(db_instance_id, options = {})
      request = SnapshotsDeleteRequest.new
      request.db_instance_id = db_instance_id
      options[:older_than] ||= { days: 14 }
      if options[:older_than].is_a? Hash
        request.older_than = Time.now
                                 .prev_year(options[:older_than][:years])
                                 .prev_month(options[:older_than][:months])
                                 .prev_hour(options[:older_than][:hours])
                                 .prev_day(options[:older_than][:days])
      elsif options[:older_than].is_a? Time
        request.older_than = options[:older_than]
      end
      SnapshotsDeleteDirector.new(config).delete(request)
    end

    # Gets the latest snapshot that was made for the RDS instance
    #
    # @param db_instance_id [String] The RDS instance id
    #
    # @example Get the snapshot ID
    #   AwsHelpers::RDS.new.latest_snapshot(db_instance_identifier)
    #
    # @return [String] The latest snapshot id for the instance
    #
    def latest_snapshot(db_instance_id)
      request = GetLatestSnapshotIdRequest.new
      request.db_instance_id = db_instance_id
      GetLatestSnapshotIdDirector.new(config).get(request)
      request.snapshot_id
    end
  end
end
