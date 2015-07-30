module AwsHelpers

  module CloudFormation

    class StackCreate

      def initialize(config, stack_name, template, options)

        @config = config # aws_cloud_formation_client, aws_s3_client
        @stack_name = stack_name
        @template = template
        @options = options

      end

      def execute

      end

    end

  end

end
