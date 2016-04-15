require_relative 'stack_exists'
require_relative 'stack_progress'

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
          @stack_exists = StackExists.new(@config, @stack_name)
        end

        def execute
          @stdout.puts "Deleting #{@stack_name}"
          return unless @stack_exists.execute
          response = @cloud_formation_client.describe_stacks(stack_name: @stack_name).stacks.first
          @options[:stack_id] = response.stack_id
          @cloud_formation_client.delete_stack(stack_name: @stack_name)
          AwsHelpers::Actions::CloudFormation::StackProgress.new(@config, @options).execute
        end
      end
    end
  end
end
