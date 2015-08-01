module AwsHelpers

  module CloudFormationActions

    class StackModifyParameters

      # @param config [AwsHelpers::CloudFormation::Config] config object with access methods to aws_cloud_formation_client
      # @param stack_name [String] Name given to the Stack
      # @param parameters [Array] List of parameters to add or modify

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