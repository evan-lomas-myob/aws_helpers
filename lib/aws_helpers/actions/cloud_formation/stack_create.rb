require_relative 'stack_progress'

module AwsHelpers
  module Actions
    module CloudFormation
      class StackCreate
        def initialize(config, request, options = {})
          @config = config
          @cloud_formation_client = @config.aws_cloud_formation_client
          @request = request
          @stack_name = request[:stack_name]
          @stdout = options[:stdout] || $stdout
        end

        def execute
          @stdout.puts "Creating #{@stack_name}"
          @cloud_formation_client.create_stack(@request)
          AwsHelpers::Actions::CloudFormation::StackProgress.new(@config, stack_name: @stack_name, stdout: @stdout).execute
        end
      end
    end
  end
end
