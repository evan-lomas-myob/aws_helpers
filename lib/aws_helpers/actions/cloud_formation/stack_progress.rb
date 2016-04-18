require_relative 'poll_stack_status'
require_relative 'stack_error_events'
require_relative 'check_stack_failure'

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
          AwsHelpers::Actions::CloudFormation::PollStackStatus.new(@config, @stack_id, stdout: @options[:stdout], delay: @options[:delay], max_attempts: @options[:max_attempts]).execute
          AwsHelpers::Actions::CloudFormation::StackErrorEvents.new(@config, @stack_id, stdout: @options[:stdout]).execute
          AwsHelpers::Actions::CloudFormation::CheckStackFailure.new(@config, @stack_id).execute
        end
      end
    end
  end
end
