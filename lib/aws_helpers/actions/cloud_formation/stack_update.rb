require_relative 'stack_progress'

module AwsHelpers
  module Actions
    module CloudFormation
      class StackUpdate
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

          begin
            @stdout.puts "Updating #{@stack_name}"
            client.update_stack(@request)
            AwsHelpers::Actions::CloudFormation::StackProgress.new(@config, @options).execute
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
