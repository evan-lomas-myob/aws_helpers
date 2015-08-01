module AwsHelpers
  module Actions
    module CloudFormation

      class StackInformation

        def initialize(config, stack_name, info_field)
          @config = config
          @stack_name = stack_name
          @info_field = info_field
        end

        def execute

        end

      end

    end
  end
end