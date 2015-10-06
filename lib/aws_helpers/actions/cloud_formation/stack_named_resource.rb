module AwsHelpers
  module Actions
    module CloudFormation

      class StackNamedResource

        def initialize(config, stack_name, resource_id)
          @config = config
          @stack_name = stack_name
          @resource_id = resource_id
        end

        def execute
          client = @config.aws_cloud_formation_client
          client.describe_stack_resource(stack_name: @stack_name, logical_resource_id: @resource_id).stack_resource_detail
        end

      end

    end

  end

end