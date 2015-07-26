require 'aws-sdk-core'
require_relative '../common/client'

module AwsHelpers

  module RDS

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(options)
      end

      def snapshot_create(db_instance_id, use_name = false)
#        RDS::Snapshot.new(aws_rds_client, aws_iam_client, db_instance_id, use_name).create
      end

      def snapshots_delete(db_instance_id, options = nil)
#        RDS::Snapshot.new(aws_rds_client, aws_iam_client, db_instance_id).delete(options)
      end

      def snapshot_latest(db_instance_id)
#        RDS::Snapshot.new(aws_rds_client, aws_iam_client, db_instance_id).latest
      end

      private

      def aws_rds_client
        @aws_rds_client ||= Aws::RDS::Client.new(@options)
      end

      def aws_iam_client
        @aws_iam_client ||= Aws::IAM::Client.new(@options)
      end

    end

  end

end

