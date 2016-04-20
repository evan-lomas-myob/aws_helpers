require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class ImageAddUserCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          @client.modify_image_attribute(image_id: @request.image_id,
                                         launch_permission: create_launch_permission(@request.user_id))
        end

        private

        def create_launch_permission(user_id)
          { add: [{ user_id: user_id }] }
        end
      end
    end
  end
end
