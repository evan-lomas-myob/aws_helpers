require 'aws_helpers/actions/ec2/tag_resource'

module AwsHelpers
  module Actions
    module EC2

      class TagImage

        def initialize(config, image_id, image_name, time, additional_tags = [])
          @config = config
          @image_id = image_id
          @image_name = image_name
          @time = time
          @additional_tags = additional_tags
        end

        def execute
          tags = [
            { key: 'Name', value: @image_name },
            { key: 'Date', value: @time.to_s }
          ] + @additional_tags
          TagResource.new(@config, @image_id, tags).execute
        end

      end
    end
  end
end
