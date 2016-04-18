require_relative 'stack_progress'

module AwsHelpers
  module Actions
    module CloudFormation
      class StackUpdate
        def initialize(config, request, options = {})
          @config = config
          @stack_name = request[:stack_name]
          @request = request
          @options = options
          @stdout = options[:stdout] || $stdout
        end

        def execute
          client = @config.aws_cloud_formation_client

          begin
            @stdout.puts "Updating #{@stack_name}"
            response = client.update_stack(@request)
            AwsHelpers::Actions::CloudFormation::StackProgress.new(
                @config, response.stack_id, stdout: @stdout, delay:@options[:delay], max_attempts:@options[:max_attempts]).execute
          rescue Aws::CloudFormation::Errors::ValidationError => validation_error
            if validation_error.message == 'No updates are to be performed.'
              @stdout.puts "No updates to perform for #{@stack_name}."
            else
              raise validation_error
            end
          end
        end
      end
    end
  end
end
