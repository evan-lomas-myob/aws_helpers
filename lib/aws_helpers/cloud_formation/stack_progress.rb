require 'aws-sdk-core'
require_relative 'poll_stack_status'
require_relative 'stack_error_events'
require_relative 'check_stack_failure'

module AwsHelpers
  module CloudFormation
    class StackProgress

      def initialize(stack_name, client = Aws::CloudFormation::Client.new)
        @pollStackStatus = PollStackStatus.new(stack_name, client)
        @stackErrorEvents = StackErrorEvents.new(stack_name, client)
        @checkStackFailure = CheckStackFailure.new(stack_name, client)
      end

      def execute
        @pollStackStatus.execute
        @stackErrorEvents.execute
        @checkStackFailure.execute
      end

    end
  end
end
