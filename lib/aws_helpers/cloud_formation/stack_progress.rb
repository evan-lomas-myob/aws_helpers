require_relative 'poll_stack_status'
require_relative 'stack_error_events'
require_relative 'check_stack_failure'

module AwsHelpers
  module CloudFormation
    class StackProgress

      def initialize(cloud_formation_client, stack_name)
        @pollStackStatus = PollStackStatus.new(cloud_formation_client, stack_name)
        @stackErrorEvents = StackErrorEvents.new(cloud_formation_client, stack_name)
        @checkStackFailure = CheckStackFailure.new(cloud_formation_client, stack_name)
      end

      def execute
        @pollStackStatus.execute
        @stackErrorEvents.execute
        @checkStackFailure.execute
      end

    end
  end
end
