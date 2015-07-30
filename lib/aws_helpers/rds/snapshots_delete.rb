module AwsHelpers

  module RDS

    class SnapshotsDelete

      def initialize(config, db_instance_id, options)

        @config = config # aws_rds_client, aws_iam_client
        @db_instance_id = db_instance_id
        @options = options

      end

      def execute

      end

    end

  end

end