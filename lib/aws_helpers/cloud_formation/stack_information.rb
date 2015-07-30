module AwsHelpers

  module CloudFormation

    class StackInformation

      def initialize(config, stack_name, info_field)

        @config = config #aws_cloud_formation_client
        @stack_name = stack_name
        @info_field = info_field

      end

      def execute

      end

    end

  end

end
