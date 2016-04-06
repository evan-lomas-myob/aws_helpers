require 'aws_helpers/rds/commands/command'

module AwsHelpers
  module RDS
    module Commands
      class SnapshotConstructNameCommand < AwsHelpers::RDS::Commands::Command

        def initialize(config, request)
          @iam_client = config.aws_iam_client
          @rds_client = config.aws_rds_client
          @request = request
          @db_instance_id = request.db_instance_identifier
          @use_name = request.use_name
          @now = request.now || Time.now
        end

        def execute
          now_formatted = @now.strftime('%Y-%m-%d-%H-%M')
          @request.snapshot_name = "#{@use_name ? name_tag_value : @db_instance_id}-#{now_formatted}"
        end

        private

        def region
          @iam_client.config.region
        end

        def iam_user_arn
          @iam_client.list_users.users.first.arn[/::(.*):/, 1]
        end

        def name_tag_value
          response = @rds_client.list_tags_for_resource(resource_name: "arn:aws:rds:#{region}:#{iam_user_arn}:db:#{@db_instance_id}")
          name_tag = response.tag_list.detect { |tag| tag.key == 'Name' }
          name_tag.value
        end

      end
    end
  end
end
