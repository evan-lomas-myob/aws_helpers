require_relative 'stack_exists'
require_relative 'stack_progress'
require_relative 'describe_stack'

module AwsHelpers
  module CloudFormation
    class StackDelete

      def initialize(cloud_formation_client, stack_name)
        @cloud_formation_client = cloud_formation_client
        @stack_name = stack_name
        @stack_exists = StackExists.new(cloud_formation_client, stack_name)
        @describe_stack = DescribeStack.new(cloud_formation_client, stack_name)
      end

      def execute
        puts "Deleting #{@stack_name}"
        return unless @stack_exists.execute

        stack = @describe_stack.execute
        stack_id = stack[:stack_id]
        @cloud_formation_client.delete_stack(stack_name: @stack_name)
        StackProgress.new(@cloud_formation_client, stack_id).execute
      end

    end

  end
end