module AwsHelpers
  module Actions
    module EC2

      class ImagesDeleteByTime

        def initialize(config, tag_name_value, creation_time)
          @config = config
          @tag_name_value = tag_name_value
          @creation_time = creation_time
        end

        def execute
          response = ImagesFindByTags.new(@config, [ {name: 'Name', value: @tag_name_value} ]).execute
          response.images.each do |image|
            next unless image.state == 'available'
            should_delete = Time.parse(image.creation_date) <= @creation_time
            @config.aws_ec2_client.deregister_image(image_id: image.image_id) if should_delete
          end
        end

      end

    end
  end
end