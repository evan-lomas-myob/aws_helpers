require 'aws_helpers/ec2_commands/commands/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class PollImageAvailableCommand < AwsHelpers::EC2Commands::Commands::Command
        include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @ec2_client = config.aws_ec2_client
          @request = request
        end

        def execute
          @image_id = @request.image_id

          @max_attempts = @request.image_polling[:max_attempts] || 60
          @delay = @request.image_polling[:delay] || 30
          poll(@delay, @max_attempts) do
            response = @ec2_client.describe_images(filters:
              [
                {
                  name: 'image-id',
                  values: [@image_id]
                }
              ])
            # response = @ec2_client.describe_instances(instance_ids: [@instance_identifier])
            image = response.images.first
            # response = @ec2_client.describe_images(image_identifier: @image_name)
            # image = response.images.find { |s| s.image_identifier == @image_name }
            # binding.pry
            status = image.state
            @request.stdout.puts "EC2 Image #{@request.image_name} #{status}"
            raise "EC2 Failed to create image #{@request.image_name}" if status == 'failed'
            status == 'available'
          end
        end
      end
    end
  end
end
