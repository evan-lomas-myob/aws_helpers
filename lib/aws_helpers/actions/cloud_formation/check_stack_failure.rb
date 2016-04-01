require 'aws_helpers/utilities/target_stack_validate'

module AwsHelpers
  module Actions
    module CloudFormation
      class CheckStackFailure
        def initialize(config, options)
          @config = config
          @target_stack = AwsHelpers::Utilities::TargetStackValidate.new.execute(options)
        end

        def execute
          failures = %w(UPDATE_ROLLBACK_COMPLETE ROLLBACK_COMPLETE ROLLBACK_FAILED UPDATE_ROLLBACK_FAILED DELETE_FAILED)
          client = @config.aws_cloud_formation_client
          stack = client.describe_stacks(stack_name: @target_stack).stacks.first
          raise "Stack #{stack.stack_name} Failed" if failures.include?(stack.stack_status)
        end
      end
    end
  end
end
