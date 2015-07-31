module AwsHelpers

  module CloudFormation

    class StackCreate

      # @param config [AwsHelpers::CloudFormation::Config] config object with access methods to aws_cloud_formation_client and aws_s3_client
      # @param stack_name [String] Name given to the Stack
      # @param template [String] Name of the JSON template in the S3 bucket to use to create the stack
      # @param options [Hash] Optional Arguments to include when calling the AWS SDK

      def initialize(config, stack_name, template, options)

        @config = config
        @stack_name = stack_name
        @template = template
        @options = options

      end

      def execute

      end

    end

  end

end
