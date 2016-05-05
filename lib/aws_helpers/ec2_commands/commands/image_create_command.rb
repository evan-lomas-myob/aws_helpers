require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class ImageCreateCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          @request.image_id = @client.create_image(
            instance_id: @request.instance_id,
            name: @request.image_name,
            description: @request.image_name
          ).image_id
        end
      end
    end
  end
end
