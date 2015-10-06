require_relative 'describe_stack'
require_relative 'stack_status'

module AwsHelpers
  module CloudFormation

    class CheckStackFailure

      def initialize(cloud_formation_client, stack_name)
        @describe_stack = DescribeStack.new(cloud_formation_client, stack_name)
      end

      def execute
        aws_stack = @describe_stack.execute
        status = aws_stack[:stack_status]
        name = aws_stack[:stack_name]

        if [UPDATE_ROLLBACK_COMPLETE, ROLLBACK_COMPLETE, ROLLBACK_FAILED, UPDATE_ROLLBACK_FAILED, DELETE_FAILED].include?(status)
          raise "Stack #{name} Failed"
        end

      end

    end

  end
end