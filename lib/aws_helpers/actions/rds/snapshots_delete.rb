module AwsHelpers

  module RDSActions

    class SnapshotsDelete

      def initialize(config, db_instance_id, days ,months ,years)

        # @param config [AwsHelpers::RDS::Config] access class for Aws::RDS::Client & Aws::IAM::Client
        # @param db_instance_id [String] Unique ID of the RDS instance
        # @param days [Integer] Minus number of days to delete snapshots from
        # @param months [Integer] Minus number of months to delete snapshots from
        # @param years [Integer] Minus number of years to delete snapshots from

        @config = config
        @db_instance_id = db_instance_id
        @days = days
        @months = months
        @years = years

      end

      def execute

      end

    end

  end

end