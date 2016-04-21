require 'aws_helpers/command'

module AwsHelpers
  module RDSCommands
    module Commands
      class SnapshotConstructNameCommand < AwsHelpers::Command

        def initialize(config, request)
          @rds_client = config.aws_rds_client
          @iam_client = config.aws_iam_client
          @request = request
        end

        def execute
          now_formatted = Time.now.strftime('%Y-%m-%d-%H-%M')
          @request.image_name = "#{@request.use_name ? name_tag_value : @request.db_instance_id}-#{now_formatted}"
        end

        private

        def region
          @iam_client.config.region
        end

        def iam_user_arn
          @iam_client.list_users.users.first.arn[/::(.*):/, 1]
        end

        def name_tag_value
          puts iam_user_arn
          response = @rds_client.list_tags_for_resource(resource_name: "arn:aws:rds:#{region}:#{iam_user_arn}:db:#{@request.db_instance_id}")
          name_tag = response.tag_list.detect { |tag| tag.key == 'Name' }
          name_tag.value
        end

      end
    end
  end
end
