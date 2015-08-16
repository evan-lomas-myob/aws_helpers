require 'aws_helpers/utilities/delete_time_builder'

module AwsHelpers
  module Actions
    module EC2

      class ImagesDelete

        def initialize(config, tag_name_value, hours, days, months, years)
          @config = config
          @tag_name_value = tag_name_value
          @delete_time = AwsHelpers::Utilities::DeleteTimeBuilder.new.build(hours: hours, days: days, months: months, years: years)
        end

        def execute
          AwsHelpers::Actions::EC2::ImagesDeleteByTime.new(@config, @tag_name_value, @delete_time).execute
        end

      end

    end
  end
end