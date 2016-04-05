require 'aws_helpers/actions/ec2/poll_image_available'

module AwsHelpers
  module Actions
    module EC2
      class ImageAddUser
        def initialize(config, image_id, user_id, options = {})
          @config = config
          @client = config.aws_ec2_client
          @image_id = image_id
          @user_id = user_id
          @stdout = options[:stdout] || $stdout
        end

        def execute
          @stdout.puts "Sharing Image #{@image_id} with #{@user_id}"
          PollImageAvailable.new(@config, @image_id, stdout: @stdout).execute
          @client.modify_image_attribute(image_id: @image_id, launch_permission: create_launch_permission(@user_id))
        end

        private

        def create_launch_permission(user_id)
          {
            add: [
              {
                user_id: user_id
              }
            ]
          }
        end
      end
    end
  end
end
