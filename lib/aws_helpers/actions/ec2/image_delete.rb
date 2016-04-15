require 'aws_helpers/actions/ec2/poll_image_deleted'
require 'aws_helpers/actions/ec2/snapshots_delete'

module AwsHelpers
  module Actions
    module EC2
      class ImageDelete
        def initialize(config, image_id, options = {})
          @config = config
          @client = config.aws_ec2_client
          @image_id = image_id
          @stdout = options[:stdout] || $stdout
          @delay = options[:delay]
          @max_attempts = options[:max_attempts]
        end

        def execute
          @stdout.puts "Deleting Image:#{@image_id}"
          response = @client.describe_images(image_ids: [@image_id])
          snapshot_ids = snapshot_ids(response.images.first)
          @client.deregister_image(image_id: @image_id)
          PollImageDeleted.new(@config, @image_id, stdout: @stdout, delay: @delay, max_attempts: @max_attempts).execute
          SnapshotsDelete.new(@config, snapshot_ids, stdout: @stdout).execute
        end

        private

        def snapshot_ids(image)
          snapshot_ids = []
          image.block_device_mappings.each do |device_mapping|
            ebs = device_mapping.ebs
            snapshot_ids << ebs.snapshot_id if ebs && !ebs.snapshot_id.to_s.empty?
          end
          snapshot_ids
        end
      end
    end
  end
end
