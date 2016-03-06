require 'aws_helpers/utilities/polling'

module AwsHelpers
  module Actions
    module EC2

      class PollImageDeleted
        include AwsHelpers::Utilities::Polling

        def initialize(config, image_id, options = {})
          @client = config.aws_ec2_client
          @image_id = image_id
          @stdout = options[:stdout] || $stdout
          @delay = options[:delay] || 15
          @max_attempts = options[:max_attempts] || 4
        end

        def execute
          poll(@delay, @max_attempts) {
            response = @client.describe_images(image_ids: [@image_id])
            image = response.images.first
            message = "Deleting Image:#{@image_id}"
            message << " State:#{image.state}" if image
            @stdout.puts message
            image.nil?
          }
        end

      end
    end
  end
end
