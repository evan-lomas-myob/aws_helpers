require_relative 'stack_parameter_update_builder'
require_relative 'stack_progress'

module AwsHelpers
  module Actions
    module CloudFormation

      class StackModifyParameters

        def initialize(config, stack_name, parameters, options = {})
          @config = config
          @stack_name = stack_name
          @parameters = parameters
          @stdout = options[:stdout] || $stdout
          @options = create_options(@stdout, options[:polling])
        end

        def execute
          client = @config.aws_cloud_formation_client
          response = client.describe_stacks(stack_name: @stack_name).stacks.first
          request = AwsHelpers::Actions::CloudFormation::StackParameterUpdateBuilder.new(@stack_name, response, @parameters).execute
          @stdout.puts "Updating #{@stack_name}"
          client = @config.aws_cloud_formation_client
          client.update_stack(request)
          AwsHelpers::Actions::CloudFormation::StackProgress.new(@config, @options).execute
        end

        private

        def create_options(stdout, pooling)
          options = {}
          options[:stack_name] = @stack_name
          options[:stdout] = stdout if stdout
          if pooling
            max_attempts = pooling[:max_attempts]
            delay = pooling[:delay]
            options[:max_attempts] = max_attempts if max_attempts
            options[:delay] = delay if delay
          end
          options
        end

      end

    end
  end
end