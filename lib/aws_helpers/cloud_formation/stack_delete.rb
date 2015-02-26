require 'aws-sdk-core'
require_relative 'stack_exists'
require_relative 'stack_progress'
require_relative 'describe_stack'

module AwsHelpers
  module CloudFormation
    class StackDelete

      def initialize(stack_name, client = Aws::CloudFormation::Client.new)
        @stack_name = stack_name
        @client = client
        @stack_exists = StackExists.new(stack_name, client)
        @describe_stack = DescribeStack.new(stack_name, client)
      end

      def execute
        puts "Deleting #{@stack_name}"
        return unless @stack_exists.execute

        stack = @describe_stack.execute
        stack_id = stack[:stack_id]
        @client.delete_stack(stack_name: @stack_name)
        StackProgress.new(stack_id, @client).execute
      end

    end

  end
end