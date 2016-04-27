require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class PollImageAvailableCommand < AwsHelpers::Command
        # include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @ec2_client = config.aws_ec2_client
          @request = request
        end

        def execute
          poll(@request.image_polling[:delay], @request.image_polling[:max_attempts]) do
            response = @ec2_client.describe_images(image_ids: [@request.image_id])
            image = response.images.first
            status = image.state
            std_out.puts "EC2 Image #{@request.image_name} #{status}"
            raise "EC2 Failed to create image #{@request.image_name}" if status == 'failed'
            status == 'available'
          end
        end
      end
    end
  end
end
