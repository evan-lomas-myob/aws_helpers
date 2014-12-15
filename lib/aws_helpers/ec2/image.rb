require 'aws-sdk-core'

module AwsHelpers
  module EC2
    class Image

      def initialize(name)
        @name = name
        @date = DateTime.now.strftime('%Y-%m-%d-%H-%M')
        @ec2 = Aws::EC2::Client.new

      end

      def create(instance_id)
        image_name = "#{@name} #{@date}"
        puts "Creating Image #{image_name}"
        begin
          image_id = create_image(image_name, instance_id)
          raise 'An Error has happened'
          tag_image(image_id)
          poll_image_available(image_id)
          image_id
        rescue
          begin
            poll_image_available(image_id) if image_id
          rescue
            # _ Needed because deletion will fail if the image hasn't finished processing
          end
          delete_by_id(image_id) if image_id
          raise
        end
      end

      private

      def delete_by_id(image_id)
        puts "Deleting Image #{image_id}"
        images_response = @ec2.describe_images(image_ids: [image_id])
        @ec2.deregister_image(image_id: image_id)
        snapshot_ids = image_snapshot_ids(images_response)
        snapshot_ids.each { |snapshot_id|
          puts "Deleting Snapshot #{snapshot_id}"
          @ec2.delete_snapshot(snapshot_id: snapshot_id)
        }
      end

      def create_image(image_name, instance_id)
        image_response = @ec2.create_image(instance_id: instance_id, name: image_name, description: image_name)
        image_response[:image_id]
      end

      def tag_image(image_id)
        @ec2.create_tags(resources: [image_id], tags: [{ key: 'Name', value: @name }, { key: 'Date', value: @date }])
      end

      def poll_image_available(image_id)
        @ec2.wait_until(:image_available, image_ids: [image_id]) { |waiter|
          waiter.interval = 60 # number of seconds to sleep between attempts
          waiter.max_attempts = 60 # maximum number of polling attempts
          waiter.before_wait { |attempts, prev_response|
            snapshot_ids = image_snapshot_ids(prev_response)
            describe_snapshot_progress(snapshot_ids)
            puts "Image #{image_id} Not Available... Waiting #{attempts * waiter.interval} seconds"
          }
        }
        puts "Image #{image_id} Available"
      end

      def image_snapshot_ids(images_response)
        snapshot_ids = []
        images_response[:images].each { |image|
          image[:block_device_mappings].each { |device_mapping|
            ebs = device_mapping[:ebs]
            snapshot_ids << ebs[:snapshot_id] if ebs
          }
        }
        snapshot_ids
      end

      def describe_snapshot_progress(snapshot_ids)
        unless snapshot_ids.empty?
          snapshots_response = @ec2.describe_snapshots(snapshot_ids: snapshot_ids)
          snapshots_response[:snapshots].each { |snapshot|
            puts "Snapshot #{snapshot[:snapshot_id]} Progress #{snapshot[:progress]}"
          }
        end
      end

    end
  end
end