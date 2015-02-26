require 'aws-sdk-core'

module AwsHelpers
  module CloudFormation

    class DescribeStack

      def initialize(stack_name, client = Aws::CloudFormation::Client.new)
        @stack_name = stack_name
        @client = client
      end

      def execute
        @client.describe_stacks(stack_name: @stack_name)[:stacks].first
      end

    end

  end
end