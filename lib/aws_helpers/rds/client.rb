require 'aws-sdk-core'
require_relative '../common/client'
require_relative 'config'
require_relative 'snapshot'

module AwsHelpers

  module RDS

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(AwsHelpers::RDS::Config.new(options))
      end

      def snapshot_create(db_instance_id, use_name = false)
        AwsHelpers::RDS::Snapshot.new(config.aws_rds_client, config.aws_iam_client, db_instance_id, use_name).create
      end

      def snapshots_delete(db_instance_id, options = nil)
        AwsHelpers::RDS::Snapshot.new(config.aws_rds_client, config.aws_iam_client, db_instance_id).delete(options)
      end

      def snapshot_latest(db_instance_id)
        AwsHelpers::RDS::Snapshot.new(config.aws_rds_client, config.aws_iam_client, db_instance_id).latest
      end

    end

  end

end

