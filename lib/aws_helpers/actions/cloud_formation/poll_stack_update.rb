require 'aws_helpers/utilities/wait_helper'

include AwsHelpers::Utilities

module AwsHelpers
  module Actions
    module CloudFormation

      class PollStackUpdate

        # CREATE_IN_PROGRESS
        # CREATE_FAILED
        # CREATE_COMPLETE
        # ROLLBACK_IN_PROGRESS
        # ROLLBACK_FAILED
        # ROLLBACK_COMPLETE
        # DELETE_IN_PROGRESS
        # DELETE_FAILED
        # DELETE_COMPLETE
        # UPDATE_IN_PROGRESS
        # UPDATE_COMPLETE_CLEANUP_IN_PROGRESS
        # UPDATE_COMPLETE
        # UPDATE_ROLLBACK_IN_PROGRESS
        # UPDATE_ROLLBACK_FAILED
        # UPDATE_ROLLBACK_COMPLETE
        # CLEANUP_IN_PROGRESS
        # UPDATE_ROLLBACK_COMPLETE

        def initialize(stdout, config, stack_name, timeout)
          @stdout = stdout
          @config = config
          @stack_name = stack_name
          @timeout = timeout
        end

        def execute
          client = @config.aws_cloud_formation_client
          WaitHelper.wait(client, @timeout, :stack_update_complete, stack_name: @stack_name) { |_attempts, response|
            stack_status = response.stack_status
            @stdout.puts "Stack - #{@stack_name} status #{stack_status}"
          }
        end

      end

    end

  end
end
