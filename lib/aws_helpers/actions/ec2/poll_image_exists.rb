require 'aws-sdk-core'
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
          @delay = options[:delay] || 5
          @max_attempts = options[:max_attempts] || 3
        end

        def execute
          poll(@delay, @max_attempts) {
            @stdout.puts "Waiting for Image:#{@image_id} to be created"
            begin
              response = @client.describe_images(image_ids: [@image_id])
              response.images.size == 1
            rescue Aws::EC2::Errors::InvalidAMIIDNotFound
              false
            end
          }
        end

      end
    end
  end
end
