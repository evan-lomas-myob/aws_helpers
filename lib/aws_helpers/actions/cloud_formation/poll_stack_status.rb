require 'aws_helpers/utilities/polling'

module AwsHelpers
  module Actions
    module CloudFormation
      class PollStackStatus
        include AwsHelpers::Utilities::Polling

        def initialize(config, stack_id, options = {})
          @client = config.aws_cloud_formation_client
          @stack_id = stack_id
          @stdout = options[:stdout] || $stdout
          @delay = options[:delay] || 30
          @max_attempts = options[:max_attempts] || 40
        end

        def execute
          finished_states = %w(CREATE_COMPLETE DELETE_COMPLETE ROLLBACK_COMPLETE UPDATE_COMPLETE UPDATE_ROLLBACK_COMPLETE ROLLBACK_FAILED UPDATE_ROLLBACK_FAILED DELETE_FAILED)
          poll(@delay, @max_attempts) do
            response = @client.describe_stacks(stack_name: @stack_id).stacks.first
            output = "Stack - #{response.stack_name} status #{response.stack_status}"
            @stdout.puts(output)
            finished_states.include?(response.stack_status)
          end
        end
      end
    end
  end
end
