require 'aws_helpers/actions/ec2/poll_image_exists'
require 'aws_helpers/actions/ec2/tag_image'
require 'aws_helpers/actions/ec2/poll_image_available'

module AwsHelpers
  module Actions
    module EC2

      class ImageCreate

        def initialize(config, instance_id, name, options = {})
          @config = config
          @client = @config.aws_ec2_client
          @instance_id = instance_id
          @name = name
          @now = options[:now] || Time.now
          @additional_tags = options[:additional_tags] || []
          @stdout = options[:stdout] || $stdout
        end

        def execute
          image_name = "#{@name} #{@now.strftime('%Y-%m-%d-%H-%M')}"
          @stdout.puts "Creating Image #{image_name}"
          image_response = @client.create_image(instance_id: @instance_id, name: image_name, description: image_name)
          image_id =image_response.image_id
          PollImageExists.new(@config, image_id).execute
          TagImage.new(@config, image_id, image_name, @now, @additional_tags).execute
          PollImageAvailable.new(@config, image_id).execute
          #TODO: Delete image on Error

        end

      end
    end
  end
end