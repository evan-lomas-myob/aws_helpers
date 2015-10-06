module AwsHelpers
  module Actions
    module CloudFormation

      class StackCreate

        def initialize(config, stack_name, request, options = {})
          @config = config
          @stack_name = stack_name
          @request = request
          @options = options
          @stdout = options[:stdout] || $stdout
        end

        def execute

          client = @config.aws_cloud_formation_client

          @stdout.puts "Creating #{@stack_name}"
          client.create_stack(@request)

          AwsHelpers::Actions::CloudFormation::PollStackStatus.new(@config, @stack_name, @options).execute
          AwsHelpers::Actions::CloudFormation::StackErrorEvents.new(@config, @stack_name, @stdout).execute
          AwsHelpers::Actions::CloudFormation::CheckStackFailure.new(@config, @stack_name).execute

        end

      end
    end
  end
end