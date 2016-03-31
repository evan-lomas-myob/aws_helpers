module AwsHelpers
  module Actions
    module CloudFormation

      class StackDeleteChangeSet

        def initialize(config, stack_name, change_set_name, options = {})
          @config = config
          @stack_name = stack_name
          @change_set_name = change_set_name
          @options = options
          @stdout = options[:stdout] || $stdout
        end

        def execute
          change_set = {
              stack_name: "#{@stack_name}",
              change_set_name: "#{@change_set_name}"
          }
          client = @config.aws_cloud_formation_client
          @stdout.puts "Deleting Change Set #{@change_set_name}"
          client.delete_change_set(change_set)
        end

      end
    end
  end
end