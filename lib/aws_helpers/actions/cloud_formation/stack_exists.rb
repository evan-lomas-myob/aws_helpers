require 'aws-sdk-resources'

module AwsHelpers
  module Actions
    module CloudFormation

      class StackExists

        def initialize(config, stack_name)
          @config = config
          @stack_name = stack_name
        end

        def execute

          client = @config.aws_cloud_formation_client
          stack = Aws::CloudFormation::Stack.new(@stack_name, client: client)
          @stack_name if stack.stack_id
        end

      end

    end
  end
end
