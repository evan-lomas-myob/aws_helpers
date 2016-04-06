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
          @stdout = options[:stdout] || $stdout
          @options = create_stack_options(@stdout, options[:polling])
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
            client.update_stack(request)
            AwsHelpers::Actions::CloudFormation::StackProgress.new(@config, @options).execute
          end
        end

        private

        def create_stack_options(stdout, polling)
            options = create_options(stdout, polling)
            options.tap{|options| options[:stack_name] = @stack_name}
        end
      end
    end
  end
end
