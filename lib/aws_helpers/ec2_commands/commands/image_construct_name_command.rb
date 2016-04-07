require 'aws_helpers/ec2_commands/commands/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class ImageConstructNameCommand < AwsHelpers::EC2Commands::Commands::Command
        def initialize(config, request)
          @ec2_client = config.aws_ec2_client
          @request = request
        end

        def execute
          @use_name = @request.use_name
          now_formatted = Time.now.strftime('%Y-%m-%d-%H-%M')
          @request.image_name = "#{@use_name ? name_tag_value : @request.instance_id}-#{now_formatted}"
        end

        private

        def name_tag_value
          response = @ec2_client.describe_tags(filters:
              [
                {
                  name: 'resource-id',
                  values: [@instance_id]
                }
              ])
          # resource_name: "arn:aws:ec2:#{region}:#{iam_user_arn}:instance:#{@instance_id}")
          name_tag = response.tags.detect { |tag| tag.key == 'Name' }
          name_tag.value
        end
      end
    end
  end
end
