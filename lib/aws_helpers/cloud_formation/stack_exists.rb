module AwsHelpers

  module CloudFormation
    class StackExists

      def initialize(config, stack_name)

        @config = config #aws_cloud_formation_client
        @stack_name = stack_name

      end

      def execute

      end

    end
  end
end