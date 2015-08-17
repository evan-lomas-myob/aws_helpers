require 'aws-sdk-resources'

module AwsHelpers
  module Actions
    module CloudFormation

      class StackExists

        def initialize(config, stack_name)
          @config = config
          @stack_name = stack_name
        end

        def execute
          client = @config.aws_cloud_formation_client

          begin
            client.describe_stacks(stack_name: @stack_name)
            true
          rescue Aws::CloudFormation::Errors::ValidationError => validation_error
            if validation_error.message == "Stack with id #{@stack_name} does not exist"
              false
            else
              raise validation_error
            end
          end

        end

      end

    end
  end
end
