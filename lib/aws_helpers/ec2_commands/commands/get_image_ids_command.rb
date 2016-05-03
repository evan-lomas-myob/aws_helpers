require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class GetImageIdsCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          filters = [
            { name: 'tag:Name', values: [@request.image_name] }
          ]
          filters += @request.with_tags.map { |k, v| { name: "tag:#{k}", values: [v] } } if @request.with_tags
          images = @client.describe_images(
            filters: filters).images
          images = images.select { |i| extract_creation_date(i) > @request.older_than } if @request.older_than
          @request.image_ids = images.map(&:image_id)
        end

        private

        def extract_creation_date(image)
          date_tag = image.tags.detect { |tag| tag[:key] == 'Date' }
          Time.parse(date_tag[:value])
        end
      end
    end
  end
end
