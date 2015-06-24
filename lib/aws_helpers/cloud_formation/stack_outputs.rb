require_relative 'describe_stack'

module AwsHelpers
  module CloudFormation
    class StackOutputs

      def initialize(cloud_formation_client, stack_name)
        @describe_stack = DescribeStack.new(cloud_formation_client, stack_name)
      end

      def execute
        stack = @describe_stack.execute
        stack[:outputs].map { |output| output.to_h }
      end

    end
  end
end