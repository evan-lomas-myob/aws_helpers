require 'aws-sdk-core'
require_relative '../common/client'
require_relative 'config'
require_relative 'snapshot_create'
require_relative 'snapshots_delete'
require_relative 'snapshot_latest'

module AwsHelpers

  module RDS

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(AwsHelpers::RDS::Config.new(options))
      end

      def snapshot_create(db_instance_id, use_name = false)
        AwsHelpers::RDS::SnapshotCreate.new(config, db_instance_id, use_name).execute
      end

      def snapshots_delete(db_instance_id, options = nil)
        AwsHelpers::RDS::SnapshotsDelete.new(config, db_instance_id, options ).execute
      end

      def snapshot_latest(db_instance_id)
        AwsHelpers::RDS::SnapshotLatest.new(config, db_instance_id).execute
      end

    end

  end

end

