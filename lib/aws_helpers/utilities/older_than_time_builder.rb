require 'aws_helpers/utilities/time'

module AwsHelpers
  module Utilities
    class OlderThanTimeBuilder
      def build(options = {})
        options ||= {}
        Time.now
            .prev_year(options[:years].to_i)
            .prev_month(options[:months].to_i)
            .prev_hour(options[:hours].to_i)
            .prev_day(options[:days].to_i)
      end
    end
  end
end
