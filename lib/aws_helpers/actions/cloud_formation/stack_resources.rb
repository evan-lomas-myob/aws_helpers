module AwsHelpers
  module Actions
    module CloudFormation
      class StackResources
        def initialize(config, stack_name)
          @client = config.aws_cloud_formation_client
          @stack_name = stack_name
        end

        def execute
          @client.describe_stack_resources(stack_name: @stack_name).stack_resources
        end
      end
    end
  end
end
