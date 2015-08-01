module AwsHelpers

  module RDSActions

    class SnapshotCreate

      def initialize(config, db_instance_id, use_name)

        # @param config [AwsHelpers::RDS::Config] access class for Aws::RDS::Client & Aws::IAM::Client
        # @param db_instance_id [String] Unique ID of the RDS instance
        # @param use_name [Boolean] Default: false

        @config = config
        @db_instance_id = db_instance_id
        @use_name = use_name

      end

      def execute

      end

    end

  end

end