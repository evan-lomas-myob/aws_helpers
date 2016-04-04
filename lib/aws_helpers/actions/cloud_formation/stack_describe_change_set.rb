module AwsHelpers
  module Actions
    module CloudFormation
      class StackDescribeChangeSet
        def initialize(config, stack_name, change_set_name, options = {})
          @config = config
          @stack_name = stack_name
          @change_set_name = change_set_name
          @options = options
          @stdout = options[:stdout] || $stdout
        end

        def execute
          client = @config.aws_cloud_formation_client
          response = client.describe_change_set(
            stack_name: @stack_name,
            change_set_name: @change_set_name
          ).changes

          if response.empty?
            @stdout.puts("No changes found in Change Set #{@change_set_name}")
          else
            output = ''
            response.each do |change|
              output << "Action: #{change.resource_change.action}\n"
              output << "Resource: #{change.resource_change.logical_resource_id}\n"
              output << "Replacement: #{change.resource_change.replacement}\n"
              change.resource_change.details.each do |detail|
                output << "\tAttribute: #{detail.target.attribute}\n"
                output << "\tName: #{detail.target.name}\n"
              end
            end
            @stdout.puts(output)
          end
        end
      end
    end
  end
end
