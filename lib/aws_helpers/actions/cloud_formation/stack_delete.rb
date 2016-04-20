require 'aws_helpers/actions/cloud_formation/stack_exists'
require 'aws_helpers/actions/cloud_formation/stack_progress'

module AwsHelpers
  module Actions
    module CloudFormation
      class StackDelete
        def initialize(config, stack_name, options = {})
          @config = config
          @cloud_formation_client = @config.aws_cloud_formation_client
          @stack_name = stack_name
          @options = options
          @stdout = options[:stdout] || $stdout
        end

        def execute
          @stdout.puts "Deleting #{@stack_name}"
          return unless StackExists.new(@config, @stack_name).execute
          response = @cloud_formation_client.describe_stacks(stack_name: @stack_name).stacks.first
          @cloud_formation_client.delete_stack(stack_name: @stack_name)
          StackProgress.new(
              @config, response.stack_id, stdout: @stdout, delay: @options[:delay], max_attempts: @options[:max_attempts]).execute
        end
      end
    end
  end
end
