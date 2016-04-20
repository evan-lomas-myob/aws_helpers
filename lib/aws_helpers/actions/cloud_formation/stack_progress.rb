require 'aws_helpers/actions/cloud_formation/poll_stack_status'
require 'aws_helpers/actions/cloud_formation/stack_error_events'
require 'aws_helpers/actions/cloud_formation/check_stack_failure'

module AwsHelpers
  module Actions
    module CloudFormation
      class StackProgress
        def initialize(config, stack_id, options = {})
          @config = config
          @stack_id = stack_id
          @options = options
        end

        def execute
          PollStackStatus.new(@config, @stack_id, stdout: @options[:stdout], delay: @options[:delay], max_attempts: @options[:max_attempts]).execute
          StackErrorEvents.new(@config, @stack_id, stdout: @options[:stdout]).execute
          CheckStackFailure.new(@config, @stack_id).execute
        end
      end
    end
  end
end
