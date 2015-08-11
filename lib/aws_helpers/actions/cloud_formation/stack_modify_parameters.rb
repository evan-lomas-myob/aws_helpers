module AwsHelpers
  module Actions
    module CloudFormation

      class StackModifyParameters

        def initialize(stdout = $stdout, config, stack_name, parameters)
          @stdout = stdout
          @config = config
          @stack_name = stack_name
          @parameters = parameters
        end

        def execute
          client = @config.aws_cloud_formation_client
          response = client.describe_stacks(stack_name: @stack_name).stacks.first
          request = AwsHelpers::Actions::CloudFormation::StackParameterUpdateBuilder.new(@stack_name, response, @parameters).execute

          client = @config.aws_cloud_formation_client
          client.update_stack(request)

          AwsHelpers::Actions::CloudFormation::PollStackUpdate.new(@stdout, @config, @stack_name, 60).execute

        end

      end

    end
  end
end