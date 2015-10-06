require 'aws_helpers/utilities/delete_time_builder'

module AwsHelpers
  module Actions
    module EC2

      class ImagesDelete

        def initialize(config, image_id, options = {})
          @config = config
          @image_id = image_id
          @options = options
          @date_time_builder = AwsHelpers::Utilities::DeleteTimeBuilder.new
        end

        def execute
          @delete_time = @date_time_builder.build(@options)
          AwsHelpers::Actions::EC2::ImagesDeleteByTime.new(@config, @image_id, @delete_time).execute
        end

      end

    end
  end
end