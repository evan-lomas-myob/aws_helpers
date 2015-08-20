require 'aws_helpers/utilities/polling'

module AwsHelpers
  module Actions
    module CloudFormation

      class PollStackStatus

        def initialize(config, stack_name, options = {})
          @config = config
          @stack_name = stack_name
          @stdout = options[:stdout] || $stdout
          @delay = options[:delay] || 15
          @max_attempts = options[:max_attempts] || 40
        end

        def execute
          states = %w(CREATE_COMPLETE DELETE_COMPLETE ROLLBACK_COMPLETE UPDATE_COMPLETE UPDATE_ROLLBACK_COMPLETE ROLLBACK_FAILED UPDATE_ROLLBACK_FAILED DELETE_FAILED)
          client = @config.aws_cloud_formation_client
          polling = AwsHelpers::Utilities::Polling.new
          polling.start(@delay, @max_attempts) {
            response = client.describe_stacks(stack_name: @stack_name).stacks.first
            output = "Stack - #{@stack_name} status #{response.stack_status}"
            @stdout.puts(output)
            polling.stop if states.include?(response.stack_status)
          }
        end

      end

    end

  end

end