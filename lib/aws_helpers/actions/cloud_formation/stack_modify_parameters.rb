require 'aws_helpers/actions/cloud_formation/stack_parameter_update_builder'
require 'aws_helpers/actions/cloud_formation/poll_stack_update'
require 'aws_helpers/actions/cloud_formation/stack_error_events'
require 'aws_helpers/actions/cloud_formation/check_stack_failure'

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

          @stdout.puts "Updating #{@stack_name}"

          client = @config.aws_cloud_formation_client
          client.update_stack(request)

          AwsHelpers::Actions::CloudFormation::PollStackUpdate.new(@stdout, @config, @stack_name, @max_attempts, @delay).execute
          AwsHelpers::Actions::CloudFormation::StackErrorEvents.new(@stdout, @config, @stack_name).execute
          AwsHelpers::Actions::CloudFormation::CheckStackFailure.new(@config, @stack_name).execute

        end

      end

    end
  end
end