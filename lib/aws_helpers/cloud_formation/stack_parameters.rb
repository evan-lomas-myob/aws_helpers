require_relative 'describe_stack'

module AwsHelpers
  module CloudFormation
    class StackParameters

      def initialize(cloud_formation_client, stack_name)
        @describe_stack = DescribeStack.new(cloud_formation_client, stack_name)
      end

      def execute
        stack = @describe_stack.execute
        stack[:parameters].map { |parameters| parameters.to_h }
      end

    end
  end
end