require 'aws_helpers/utilities/delete_time_builder'

module AwsHelpers
  module Actions
    module EC2
      class ImagesDelete
        def initialize(config, name, options = {})
          @config = config
          @name = name
          @options = options
          @date_time_builder = AwsHelpers::Utilities::DeleteTimeBuilder.new
        end

        def execute
          @delete_time = @date_time_builder.build(@options)
          AwsHelpers::Actions::EC2::ImagesDeleteByTime.new(@config, @name, @delete_time).execute
        end
      end
    end
  end
end
