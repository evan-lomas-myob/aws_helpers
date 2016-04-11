require 'aws_helpers/ec2_commands/commands/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class PollImageDeletedCommand < AwsHelpers::EC2Commands::Commands::Command
        include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @ec2_client = config.aws_ec2_client
          @request = request
        end

        def execute
          poll(@request.image_polling[:delay], @request.image_polling[:max_attempts]) do
            response = @ec2_client.describe_images(image_ids: [@request.image_id])
            image = response.images.first
            if image
              status = image.state
              @request.stdout.puts "EC2 Image #{@request.image_id} #{status}"
            end
            image.nil?
          end
        end
      end
    end
  end
end
