require 'aws_helpers/utilities/polling'

module AwsHelpers
  module Actions
    module EC2

      class PollImageExists
        include AwsHelpers::Utilities::Polling

        def initialize(config, image_id, options={})
          @client = config.aws_ec2_client
          @image_id = image_id
          @stdout = options[:stdout] || $stdout
          @delay = options[:delay] || 10
          @max_attempts = options[:max_attempts] || 3
        end

        def execute
          poll(@delay, @max_attempts) {
            response = @client.describe_images(image_ids: [@image_id])
            @stdout.puts "Waiting for Image:#{@image_id}"
            response.images.size == 1
          }
        end

      end
    end
  end
end
