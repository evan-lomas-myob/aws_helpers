require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class GetImageIdCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          response = @client.describe_images(
            filters: [
              { name: 'tag:Name', values: [@request.image_name] }
            ])
          @request.image_id = response.images.first.image_id unless response.images.empty?
        end
      end
    end
  end
end
