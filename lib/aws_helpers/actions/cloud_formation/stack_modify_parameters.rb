require_relative 'stack_parameter_update_builder'
require_relative 'stack_progress'
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
          request = AwsHelpers::Actions::CloudFormation::StackParameterUpdateBuilder.new(@stack_name, response, @parameters).execute

          if request.nil?
            @stdout.puts 'No matching parameter(s) found'
          else
            @stdout.puts "Updating #{@stack_name}"
            client = @config.aws_cloud_formation_client
            response = client.update_stack(request)
            AwsHelpers::Actions::CloudFormation::StackProgress.new(
                @config, response.stack_id, stdout: @options[:stdout], delay: @options[:delay], max_attempts: @options[:max_attempts]).execute
          end
        end

      end
    end
  end
end
