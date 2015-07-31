module AwsHelpers

  module RDS

    class SnapshotsDelete

      def initialize(config, db_instance_id, options)

        # @param options [Hash] Additional options to pass to the AWS SDK
        # @param config [AwsHelpers::RDS::Config] access class for Aws::RDS::Client & Aws::IAM::Client
        # # @param db_instance_id [String] Unique ID of the RDS instance

        @config = config
        @db_instance_id = db_instance_id
        @options = options

      end

      def execute

      end

    end

  end

end