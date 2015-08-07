module AwsHelpers
  module Actions
    module RDS

      class SnapshotConstructName

        def initialize(config, db_instance_id)
          @config = config
          @db_instance_id = db_instance_id
        end

        def execute

          iam_client = @config.aws_iam_client
          rds_client = @config.aws_rds_client
          region = iam_client.config.region
          iam_user_arn = iam_client.list_users.first.arn[/::(.*):/,1]

          resource_name = "arn:aws:rds:#{region}:#{iam_user_arn}:db:#{@db_instance_id}"
          rds_client.list_tags_for_resource(resource_name)

        end

      end

    end
  end
end