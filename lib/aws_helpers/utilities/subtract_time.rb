require 'date'
require 'time'

module AwsHelpers
  module Utilities

    class SubtractTime

      def initialize(time, days:, months:, years:)
        @time = time
        @days = days
        @months = months
        @years = years
      end

      def execute

        return @time unless @days or @months or @years

        subtract_time = DateTime.parse(@time.to_s)

        subtract_time = subtract_time.prev_day (@days) if @days
        subtract_time = subtract_time.prev_month (@months) if @months
        subtract_time = subtract_time.prev_year (@years) if @years

        Time.parse(subtract_time.to_s)

      end

    end

  end
end
