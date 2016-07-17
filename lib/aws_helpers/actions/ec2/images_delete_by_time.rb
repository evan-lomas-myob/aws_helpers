require 'aws_helpers/actions/ec2/images_delete'

module AwsHelpers
  module Actions
    module EC2
      class ImagesDeleteByTime
        def initialize(config, name_tag_value, creation_time, options = {})
          @config = config
          @name_tag_value = name_tag_value
          @creation_time = creation_time
          @stdout = options[:stdout] ||= $stdout
          @max_attempts = options[:max_attempts]
          @excluding_image_ids = options[:excluding_image_ids] ||= {}
        end

        def execute
          @stdout.puts "Deleting images tagged with Name:#{@name_tag_value} created before #{@creation_time}"
          images = ImagesFindByTags.new(@config, Name: @name_tag_value).execute
          images.each do |image|
            date_tag = image.tags.detect { |tag| tag.key == 'Date' }
            image_creation_time = Time.parse(date_tag.value)
            next if @creation_time <= image_creation_time || @excluding_image_ids.include?(image.image_id)
            #TODO: Set delay
            ImageDelete.new(@config, image.image_id, stdout: @stdout, max_attempts: @max_attempts).execute
          end
        end
      end
    end
  end
end
