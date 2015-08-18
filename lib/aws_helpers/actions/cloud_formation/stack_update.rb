require 'aws_helpers/actions/cloud_formation/poll_stack_update'
require 'aws_helpers/actions/cloud_formation/stack_error_events'
require 'aws_helpers/actions/cloud_formation/check_stack_failure'

module AwsHelpers
  module Actions
    module CloudFormation

      class StackUpdate

        def initialize(config, stack_name, request, max_attempts = 10, delay = 30, stdout = $stdout)
          @config = config
          @stack_name = stack_name
          @request = request
          @max_attempts = max_attempts
          @delay = delay
          @stdout = stdout
        end

        def execute
          client = @config.aws_cloud_formation_client

          begin
            @stdout.puts "Updating #{@stack_name}"
            client.update_stack(@request)
            AwsHelpers::Actions::CloudFormation::PollStackUpdate.new(@config, @stack_name, @max_attempts, @delay, @stdout).execute
            AwsHelpers::Actions::CloudFormation::StackErrorEvents.new(@config, @stack_name, @stdout).execute
            AwsHelpers::Actions::CloudFormation::CheckStackFailure.new(@config, @stack_name).execute
          rescue Aws::CloudFormation::Errors::ValidationError => validation_error
            if validation_error.message == 'No updates are to be performed.'
              @stdout.puts "No updates to perform for #{@stack_name}."
            else
              raise validation_error
            end
          end

        end

      end
    end
  end
end