require 'aws_helpers/actions/ec2/images_delete'

module AwsHelpers
  module Actions
    module EC2

      class ImagesDeleteByTime

        def initialize(config, name_tag_value, creation_time, options = {})
          @config = config
          @name_tag_value = name_tag_value
          @creation_time = creation_time
          @stdout = options[:stdout] || $stdout
        end

        def execute
          @stdout.puts "Deleting images tagged with Name:#{@name_tag_value} created before #{@creation_time}"
          images = ImagesFindByTags.new(@config, [{ name: 'Name', value: @name_tag_value }]).execute
          images.each do |image|
            ImageDelete.new(@config, image.image_id, stdout: @stdout).execute
          end
        end

      end

    end
  end
end