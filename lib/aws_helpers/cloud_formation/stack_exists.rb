require 'aws-sdk-core'
require_relative 'describe_stack'

module AwsHelpers
  module CloudFormation
    class StackExists

      def initialize(cloud_formation_client, stack_name)
        @stack_name = stack_name
        @describe_stack = DescribeStack.new(cloud_formation_client, stack_name)
      end

      def execute
        begin
          !@describe_stack.execute.nil?
        rescue Aws::CloudFormation::Errors::ValidationError => validation_error
          if validation_error.message == "Stack with id #{@stack_name} does not exist"
            false
          else
            raise validation_error
          end
        end
      end

    end
  end
end