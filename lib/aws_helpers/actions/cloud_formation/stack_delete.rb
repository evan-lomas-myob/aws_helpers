module AwsHelpers
  module Actions
    module CloudFormation

      class StackDelete

        def initialize(config, stack_name, options = {})
          @config = config
          @stack_name = stack_name
          @stdout = options[:stdout] || $stdout
        end

        def execute
          client = @config.aws_cloud_formation_client
          client.delete_stack(stack_name: @stack_name)
          client.wait_until(:stack_delete_complete, stack_name: @stack_name)
          @stdout.puts "Deleted #{@stack_name}"
        end

      end
    end
  end
end