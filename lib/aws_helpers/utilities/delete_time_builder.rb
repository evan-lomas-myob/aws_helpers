require 'aws_helpers/utilities/time'

module AwsHelpers
  module Utilities

    class DeleteTimeBuilder

      def build(options = {})
        (options[:time] || Time.now)
          .prev_year(options[:years])
          .prev_month(options[:months])
          .prev_hour(options[:hours])
          .prev_day(options[:days])
      end

    end
  end
end