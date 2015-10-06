module AwsHelpers
  module CloudFormation

    class DescribeStack

      def initialize(cloud_formation_client, stack_name)
        @cloud_formation_client = cloud_formation_client
        @stack_name = stack_name
      end

      def execute
        @cloud_formation_client.describe_stacks(stack_name: @stack_name)[:stacks].first
      end

    end

  end
end