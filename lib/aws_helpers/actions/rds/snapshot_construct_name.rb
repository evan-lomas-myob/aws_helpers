module AwsHelpers
  module Actions
    module RDS

      class SnapshotConstructName

        def initialize(config, db_instance_id, options = {})
          @config = config
          @db_instance_id = db_instance_id
          @use_name = options[:use_name]
          @now = options[:now] || Time.now
        end

        def execute
          now_formatted = @now.strftime('%Y-%m-%d-%H-%M')
          return "#{@db_instance_id}-#{now_formatted}" unless @use_name
          iam_client = @config.aws_iam_client
          region = iam_client.config.region
          response = iam_client.list_users
          iam_user_arn = response.users.first.arn[/::(.*):/, 1]
          rds_client = @config.aws_rds_client
          response = rds_client.list_tags_for_resource(resource_name: "arn:aws:rds:#{region}:#{iam_user_arn}:db:#{@db_instance_id}")
          name_tag = response.tag_list.detect { |tag| tag.key == 'Name' }
          "#{name_tag.value}-#{now_formatted}"
        end

      end

    end
  end
end