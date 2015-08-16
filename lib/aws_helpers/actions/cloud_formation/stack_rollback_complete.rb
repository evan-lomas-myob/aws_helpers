require 'aws-sdk-resources'

module AwsHelpers
  module Actions
    module CloudFormation

      class StackRollbackComplete

        def initialize(config, stack_name)
          @config = config
          @stack_name = stack_name
        end

        def execute
          failures = %w(ROLLBACK_COMPLETE)
          client = @config.aws_cloud_formation_client
          stack = client.describe_stacks(stack_name: @stack_name).stacks.first
          failures.include?(stack.stack_status) ? true : false
        end

      end

    end
  end
end
