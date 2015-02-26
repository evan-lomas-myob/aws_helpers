require 'aws-sdk-core'
require_relative 'describe_stack'

module AwsHelpers
  module CloudFormation
    class StackOutputs

      def initialize(stack_name, client = Aws::CloudFormation::Client.new)
        @stack_name = stack_name
        @client = client
        @describe_stack = DescribeStack.new(stack_name, client)
      end

      def execute
        stack = @describe_stack.execute
        stack[:outputs].map { |output| output.to_h }
      end

    end
  end
end