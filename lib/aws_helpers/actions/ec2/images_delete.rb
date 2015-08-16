require 'aws_helpers/utilities/delete_time_builder'

module AwsHelpers
  module Actions
    module EC2

      class ImagesDelete

        def initialize(config, tag_name_value, options = {})
          @config = config
          @tag_name_value = tag_name_value
          @options = options
          @date_time_builder = AwsHelpers::Utilities::DeleteTimeBuilder.new
        end

        def execute
          @delete_time = @date_time_builder.build(@options)
          AwsHelpers::Actions::EC2::ImagesDeleteByTime.new(@config, @tag_name_value, @delete_time).execute
        end

      end

    end
  end
end