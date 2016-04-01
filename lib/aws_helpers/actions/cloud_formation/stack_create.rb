require_relative 'stack_progress'

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
          @options[:stack_name] = @stack_name
        end

        def execute
          client = @config.aws_cloud_formation_client
          @stdout.puts "Creating #{@stack_name}"
          client.create_stack(@request)
          AwsHelpers::Actions::CloudFormation::StackProgress.new(@config, @options).execute
        end
      end
    end
  end
end
