module AwsHelpers
  module Actions
    module CloudFormation

      class StackInformation

        def initialize(config, stack_name, info_field)
          @config = config
          @stack_name = stack_name
          @info_field = info_field
        end

        def execute
          client = @config.aws_cloud_formation_client
          client.describe_stacks(stack_name: @stack_name).stacks.first.send(@info_field)
        end

      end

    end

  end

end