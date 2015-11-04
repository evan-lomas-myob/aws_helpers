module AwsHelpers
  module Actions
    module CloudFormation

      class StackDelete

        def initialize(config, stack_name, options = {})
          @config = config
          @stack_name = stack_name
          @options = options
          @stdout = options[:stdout] || $stdout
        end

        def execute
          client = @config.aws_cloud_formation_client
          @stdout.puts "Deleting #{@stack_name}"
          client.delete_stack(stack_name: @stack_name)
          AwsHelpers::Actions::CloudFormation::PollStackStatus.new(@config, @stack_name, @options).execute
        end

      end
    end
  end
end
