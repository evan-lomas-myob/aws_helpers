module AwsHelpers
  module Actions
    module CloudFormation

      class StackExists

        def initialize(config, stack_name)
          @config = config
          @stack_name = stack_name
        end

        def execute

        end

      end

    end
  end
end