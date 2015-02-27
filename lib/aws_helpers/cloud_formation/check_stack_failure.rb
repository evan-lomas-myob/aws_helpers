require 'aws-sdk-core'
require_relative 'describe_stack'
require_relative 'stack_status'

module AwsHelpers
  module CloudFormation

    class CheckStackFailure

      def initialize(stack_name, client = Aws::CloudFormation::Client.new)
        @stack_name = stack_name
        @client = client
        @describe_stack = DescribeStack.new(stack_name, client)
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