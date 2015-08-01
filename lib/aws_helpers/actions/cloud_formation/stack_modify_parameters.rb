module AwsHelpers
  module Actions
    module CloudFormation

      class StackModifyParameters

        def initialize(config, stack_name, parameters)
          @config = config
          @stack_name = stack_name
          @parameters = parameters
        end

        def execute

        end

      end

    end
  end
end