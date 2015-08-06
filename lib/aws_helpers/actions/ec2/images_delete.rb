module AwsHelpers
  module Actions
    module EC2

      class ImagesDelete

        def initialize(config, tag_name_value, hours, days, months, years, now = Time.now)
          @config = config
          @tag_name_value = tag_name_value
          @hours = hours
          @days = days
          @months = months
          @years = years
          @now = now
        end

        def execute
          creation_date = AwsHelpers::Utilities::SubtractTime.new(@now, hours: @hours, days: @days, months: @months, years: @years).execute
          AwsHelpers::Actions::EC2::ImagesDeleteByTime.new(@config, @tag_name_value, creation_date).execute
        end

      end

    end
  end
end