require 'aws_helpers/actions/ec2/tag_resource'

module AwsHelpers
  module Actions
    module EC2

      class TagImage

        def initialize(config, image_id, name, time, options={})
          @config = config
          @image_id = image_id
          @name = name
          @time = time
          @additional_tags = options[:additional_tags] || []
          @stdout = options[:stdout] || $stdout
        end

        def execute
          @stdout.puts "Tagging Image:#{@image_id}"
          tags = [
            { key: 'Name', value: @name },
            { key: 'Date', value: @time.to_s }
          ] + @additional_tags
          TagResource.new(@config, @image_id, tags).execute
        end

      end
    end
  end
end
