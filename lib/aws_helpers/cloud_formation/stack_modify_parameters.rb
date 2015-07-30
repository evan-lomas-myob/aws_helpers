module AwsHelpers

  module CloudFormation

    class StackModifyParameters

      def initialize(config, stack_name, parameters)

        @config = config #aws_cloud_formation_client
        @stack_name = stack_name
        @parameters = parameters

      end

      def execute

      end

    end

  end

end