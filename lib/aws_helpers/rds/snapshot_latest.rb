module AwsHelpers

  module RDS

    class SnapshotLatest

      def initialize(config, db_instance_id)

        # @param config [AwsHelpers::RDS::Config] access class for Aws::RDS::Client & Aws::IAM::Client
        # @param db_instance_id [String] Unique ID of the RDS instance

        @config = config
        @db_instance_id = db_instance_id

      end

      def execute

      end

    end

  end

end