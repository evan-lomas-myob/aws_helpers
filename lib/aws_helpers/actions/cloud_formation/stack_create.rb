module AwsHelpers
  module Actions
    module CloudFormation

      class StackCreate

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

          @stdout.puts "Creating #{@stack_name}"
          client.create_stack(@request)

          AwsHelpers::Actions::CloudFormation::PollStackUpdate.new(@config, @stack_name, @max_attempts, @delay, @stdout).execute
          AwsHelpers::Actions::CloudFormation::StackErrorEvents.new(@config, @stack_name, @stdout).execute
          AwsHelpers::Actions::CloudFormation::CheckStackFailure.new(@config, @stack_name).execute

        end

      end
    end
  end
end