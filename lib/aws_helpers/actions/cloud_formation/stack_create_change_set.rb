module AwsHelpers
  module Actions
    module CloudFormation

      class StackCreateChangeSet

        def initialize(config, stack_name, change_set_name, template_json, options = {})
          @config = config
          @stack_name = stack_name
          @change_set_name = change_set_name
          @template_json = template_json
          @options = options
          @stdout = options[:stdout] || $stdout
        end

        def execute
          change_set = {
              stack_name: "#{@stack_name}",
              template_body: "#{@template_json}",
              change_set_name: "#{@change_set_name}"
          }
          client = @config.aws_cloud_formation_client
          @stdout.puts "Creating Change Set #{@change_set_name}"
          client.create_change_set(change_set)
        end

      end
    end
  end
end