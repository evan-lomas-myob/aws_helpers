module AwsHelpers
  module Actions
    module CloudFormation
      class StackResources
        def initialize(config, stack_name)
          @config = config
          @stack_name = stack_name
        end

        def execute
          client = @config.aws_cloud_formation_client
          client.describe_stack_resources(stack_name: @stack_name).stack_resources.first
        end
      end
    end
  end
end
