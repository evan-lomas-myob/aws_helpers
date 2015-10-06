module AwsHelpers
  module Actions
    module CloudFormation

      class StackParameterUpdateBuilder

        def initialize(stack_name, existing_describe_stacks_output, updated_parameters)
          @stack_name = stack_name
          @existing_stack = existing_describe_stacks_output
          @updated_parameters = updated_parameters
        end

        def execute

          capabilities = @existing_stack.capabilities
          parameters = @existing_stack.parameters.map { |existing_parameter|

            update_parameter = @updated_parameters.detect { |updated_parameter|
              updated_parameter[:parameter_key] == existing_parameter.parameter_key }

            parameter_hash = existing_parameter.to_hash

            if update_parameter[:parameter_value] != existing_parameter.parameter_value
              parameter_hash[:parameter_value] = update_parameter[:parameter_value]
              parameter_hash.delete(:use_previous_value)
            else
              parameter_hash[:use_previous_value] = true
              parameter_hash.delete(:parameter_value)
            end
            parameter_hash
          }

          {
              stack_name: @stack_name,
              use_previous_template: true,
              parameters: parameters,
              capabilities: capabilities
          }

        end


      end

    end
  end
end
