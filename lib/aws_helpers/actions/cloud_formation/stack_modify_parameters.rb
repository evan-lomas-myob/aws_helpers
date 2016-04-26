require 'aws_helpers/actions/cloud_formation/stack_parameter_update_builder'
require 'aws_helpers/actions/cloud_formation/stack_progress'
require 'aws_helpers/utilities/polling_options'

module AwsHelpers
  module Actions
    module CloudFormation
      class StackModifyParameters
        include AwsHelpers::Utilities::PollingOptions

        def initialize(config, stack_name, parameters, options = {})
          @config = config
          @stack_name = stack_name
          @parameters = parameters
          @options = options
          @stdout = options[:stdout] || $stdout
        end

        def execute
          client = @config.aws_cloud_formation_client
          response = client.describe_stacks(stack_name: @stack_name).stacks.first
          request = StackParameterUpdateBuilder.new(@stack_name, response, @parameters).execute

          if request.nil?
            @stdout.puts 'No matching parameter(s) found'
          else
            @stdout.puts "Updating #{@stack_name}"
            client = @config.aws_cloud_formation_client

            #TODO: write tests around the exception handling
            begin
              response = client.update_stack(request)
              StackProgress.new(
                  @config,
                  response.stack_id,
                  stdout: @options[:stdout],
                  delay: @options[:delay],
                  max_attempts: @options[:max_attempts]).execute
            rescue Aws::CloudFormation::Errors::ValidationError => validation_error
              if validation_error.message == 'No updates are to be performed.'
                puts "No updates to perform for #{@stack_name}."
              else
                raise validation_error
              end
            end
          end
        end

      end
    end
  end
end
