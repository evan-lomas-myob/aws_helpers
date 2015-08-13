require 'aws-sdk-resources'

module AwsHelpers
  module Actions
    module CloudFormation

      class PollStackUpdate

        def initialize(stdout, config, stack_name, max_attempts, delay)
          @stdout = stdout
          @config = config
          @stack_name = stack_name
          @max_attempts = max_attempts
          @delay = delay
        end

        def execute
          client = @config.aws_cloud_formation_client
          responses = %w(CREATE_COMPLETE DELETE_COMPLETE ROLLBACK_COMPLETE UPDATE_COMPLETE UPDATE_ROLLBACK_COMPLETE ROLLBACK_FAILED UPDATE_ROLLBACK_FAILED DELETE_FAILED)
          stack_info = Aws::CloudFormation::Stack.new(@stack_name, client: client)
          stack_info.wait_until(max_attempts: @max_attempts, delay: @delay) { |stack_info|
            @stdout.puts "Stack - #{@stack_name} status #{stack_info.stack_status}"
            responses.include?(stack_info.stack_status)
          }
        end

      end

    end

  end
end
