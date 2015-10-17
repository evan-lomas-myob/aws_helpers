require 'aws_helpers/utilities/polling'
require 'aws_helpers/utilities/polling_failed'
require 'aws_helpers/actions/ec2/describe_snapshots'

module AwsHelpers
  module Actions
    module EC2

      class PollImageAvailable
        include AwsHelpers::Utilities::Polling

        def initialize(config, image_id, options = {})
          @config = config
          @client = config.aws_ec2_client
          @image_id = image_id
          @stdout = options[:stdout] || $stdout
          @delay = options[:delay] || 60
          @max_attempts = options[:max_attempts] || 60
        end

        def execute
          poll(@delay, @max_attempts) { |attempts|
            response = @client.describe_images(image_ids: [@image_id])
            image = response.images.first
            image_state = image.state
            state_message = "Image #{@image_id} #{image_state}"
            case image_state
              when 'available'
                @stdout.puts state_message
                describe_snapshots(image)
                true
              when 'pending'
                @stdout.puts "#{state_message}... Waiting #{attempts * @delay} seconds"
                describe_snapshots(image)
                false
              else
                raise AwsHelpers::Utilities::FailedStateError.new(state_message)
            end
          }
        end

        private

        def describe_snapshots(image)
          snapshot_ids = []
          image.block_device_mappings.each { |device_mapping|
            ebs = device_mapping.ebs
            snapshot_ids << ebs.snapshot_id if ebs
          }
          AwsHelpers::Actions::EC2::DescribeSnapshots.new(@config, snapshot_ids).execute
        end

      end
    end
  end
end
