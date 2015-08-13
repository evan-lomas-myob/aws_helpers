require 'aws_helpers/actions/cloud_formation/stack_parameter_update_builder'
require 'aws_helpers/actions/cloud_formation/poll_stack_update'

module AwsHelpers
  module Actions
    module CloudFormation

      class StackModifyParameters

        def initialize(stdout = $stdout, max_attempts = 10, delay = 30, config, stack_name, parameters)
          @stdout = stdout
          @config = config
          @stack_name = stack_name
          @parameters = parameters
          @max_attempts = max_attempts
          @delay = delay
        end

        def execute
          client = @config.aws_cloud_formation_client
          response = client.describe_stacks(stack_name: @stack_name).stacks.first
          request = AwsHelpers::Actions::CloudFormation::StackParameterUpdateBuilder.new(@stack_name, response, @parameters).execute

          client = @config.aws_cloud_formation_client
          client.update_stack(request)

          AwsHelpers::Actions::CloudFormation::PollStackUpdate.new(@stdout, @config, @stack_name, @max_attempts, @delay).execute
          # TODO Check completion of stack modify by recursing through events
          # TODO Report and raise exception if issues are found

        end

      end

    end
  end
end