require_relative 'poll_stack_status'
require_relative 'stack_error_events'
require_relative 'check_stack_failure'

module AwsHelpers
  module Actions
    module CloudFormation
      class StackProgress
        def initialize(config, options = {})
          @config = config
          @options = options
          @options[:stdout] ||= $stdout
        end

        def execute
          AwsHelpers::Actions::CloudFormation::PollStackStatus.new(@config, @options).execute
          AwsHelpers::Actions::CloudFormation::StackErrorEvents.new(@config, @options).execute
          AwsHelpers::Actions::CloudFormation::CheckStackFailure.new(@config, @options).execute
        end
      end
    end
  end
end
