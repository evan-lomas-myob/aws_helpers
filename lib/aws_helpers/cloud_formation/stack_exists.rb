require 'aws-sdk-core'
require_relative 'describe_stack'

module AwsHelpers
  module CloudFormation
    class StackExists

      def initialize(stack_name, client = Aws::CloudFormation::Client.new)
        @stack_name = stack_name
        @client = client
        @describe_stack = DescribeStack.new(stack_name, client)
      end

      def execute
        begin
          !@describe_stack.execute.nil?
        rescue Aws::CloudFormation::Errors::ValidationError => validation_error
          if validation_error.message == "Stack:#{@stack_name} does not exist"
            false
          else
            raise validation_error
          end
        end
      end

    end
  end
end