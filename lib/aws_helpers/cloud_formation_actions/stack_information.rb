module AwsHelpers

  module CloudFormationActions

    class StackInformation

      # @param config [AwsHelpers::CloudFormation::Config] config object with access methods to aws_cloud_formation_client
      # @param stack_name [String] Name given to the Stack
      # @param info_field [String] Valid values: "output" or "parameters"

      def initialize(config, stack_name, info_field)

        @config = config
        @stack_name = stack_name
        @info_field = info_field

        # raise FieldNotKnown

      end

      def execute

      end

    end

  end

end
