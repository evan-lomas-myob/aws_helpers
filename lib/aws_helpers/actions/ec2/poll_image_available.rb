require 'aws_helpers/utilities/polling'
require 'aws_helpers/utilities/polling_failed'
require 'aws_helpers/actions/ec2/snapshots_describe'

module AwsHelpers
  module Actions
    module EC2
      class PollImageAvailable
        include AwsHelpers::Utilities::Polling

        def initialize(config, image_id, options = {})
          @config = config
          @client = config.aws_ec2_client
          @image_id = image_id
          @stdout = options[:stdout] ||= $stdout
          @delay = options[:delay] ||= 30
          @max_attempts = options[:max_attempts] ||= 20
        end

        def execute
          poll(@delay, @max_attempts) do |attempts|
            response = @client.describe_images(image_ids: [@image_id])
            image = response.images.first
            describe_state(image, attempts)
            describe_snapshots(image)
            if image.nil? || image.state == 'pending'
              false
            elsif image.state == 'available'
              true
            else
              raise AwsHelpers::Utilities::FailedStateError.new("Image:#{@image_id} State:#{image.state}")
            end
          end
        end

        private

        def describe_state(image, attempts)
          image_state = image ? image.state : 'not created'
          case image_state
          when 'pending', 'not created'
            @stdout.puts "Waiting for Image:#{@image_id} State:#{image_state} to become available #{attempts * @delay} seconds"
          else
            @stdout.puts "Image:#{@image_id} State:#{image_state}"
          end
        end

        def describe_snapshots(image)
          return unless image
          if %w(available pending).include?(image.state)
            snapshot_ids = []
            image.block_device_mappings.each do |device_mapping|
              ebs = device_mapping.ebs
              snapshot_ids << ebs.snapshot_id if ebs && !ebs.snapshot_id.to_s.empty?
            end
            AwsHelpers::Actions::EC2::SnapshotsDescribe.new(@config, snapshot_ids).execute unless snapshot_ids.empty?
          end
        end
      end
    end
  end
end
