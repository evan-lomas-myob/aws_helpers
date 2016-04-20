module AwsHelpers
  module Actions
    module CloudFormation
      class CheckStackFailure
        def initialize(config, stack_id)
          @config = config
          @stack_id = stack_id
        end

        def execute
          failures = %w(UPDATE_ROLLBACK_COMPLETE ROLLBACK_COMPLETE ROLLBACK_FAILED UPDATE_ROLLBACK_FAILED DELETE_FAILED)
          client = @config.aws_cloud_formation_client
          stack = client.describe_stacks(stack_name: @stack_id).stacks.first
          raise "Stack #{stack.stack_name} Failed" if failures.include?(stack.stack_status)
        end
      end
    end
  end
end
