require 'aws_helpers/actions/cloud_formation/stack_progress'

module AwsHelpers
  module Actions
    module CloudFormation
      class StackCreate
        def initialize(config, request, options = {})
          @config = config
          @cloud_formation_client = @config.aws_cloud_formation_client
          @request = request
          @options = options
          @stdout = options[:stdout] ||= $stdout
        end

        def execute
          @stdout.puts "Creating #{@request[:stack_name]}"
          response = @cloud_formation_client.create_stack(@request)
          StackProgress.new(
              @config, response.stack_id, stdout: @stdout, delay:@options[:delay], max_attempts:@options[:max_attempts]).execute
        end
      end
    end
  end
end
