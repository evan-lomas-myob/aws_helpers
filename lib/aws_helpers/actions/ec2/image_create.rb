require 'aws_helpers/actions/ec2/poll_image_exists'
require 'aws_helpers/actions/ec2/tag_image'
require 'aws_helpers/actions/ec2/poll_image_available'
require 'aws_helpers/actions/ec2/image_delete'
require 'aws_helpers/utilities/polling_options'

module AwsHelpers
  module Actions
    module EC2
      class ImageCreate
        include AwsHelpers::Utilities::PollingOptions

        def initialize(config, instance_id, name, options = {})
          @config = config
          @client = config.aws_ec2_client
          @instance_id = instance_id
          @name = name
          @now = options[:now] ||= Time.now
          @additional_tags = options[:additional_tags] ||= []
          @stdout = options[:stdout] ||= $stdout
          @poll_image_available_options = create_options(@stdout, options[:poll_image_available])
        end

        def execute
          image_name = "#{@name} #{@now.strftime('%Y-%m-%d-%H-%M')}"
          @stdout.puts "Creating Image #{image_name}"
          image_response = @client.create_image(instance_id: @instance_id, name: image_name, description: image_name)
          image_id = image_response.image_id
          begin
            PollImageExists.new(@config, image_id, stdout: @stdout).execute
            TagImage.new(@config, image_id, @name, @now, additional_tags: @additional_tags, stdout: @stdout).execute
            PollImageAvailable.new(@config, image_id, @poll_image_available_options).execute
            image_id
          rescue
            ImageDelete.new(@config, image_id, stdout: @stdout).execute
            raise
          end
        end
      end
    end
  end
end
