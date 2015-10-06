require_relative 'stack_update'

module AwsHelpers
  module CloudFormation
    class StackModifyParameters

      def initialize(cloud_formation_client, stack_name, updated_parameters)
        @cloud_formation_client = cloud_formation_client
        @stack_name = stack_name
        @updated_parameters = updated_parameters
      end

      def execute
        puts "Modifying Parameters #{@stack_name}"
        StackUpdate.new(@cloud_formation_client, request).execute
      end

      private

      def request
        existing_stack = @cloud_formation_client.describe_stacks(stack_name: @stack_name)[:stacks].first

        capabilities = existing_stack[:capabilities]
        parameters = existing_stack[:parameters].map { |existing_parameter|

          update_parameter = @updated_parameters.detect { |updated_parameter|
            updated_parameter[:parameter_key] == existing_parameter[:parameter_key] }

          parameter_hash = existing_parameter.to_hash
          if update_parameter
            parameter_hash[:parameter_value] = update_parameter[:parameter_value]
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