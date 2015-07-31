module AwsHelpers

  module CloudFormation

    class StackCreate

      # @param config [AwsHelpers::CloudFormation::Config] config object with access methods to aws_cloud_formation_client and aws_s3_client
      # @param stack_name [String] Name given to the Stack
      # @param template [String] Name of the JSON template in the S3 bucket to use to create the stack
      # @param parameters [String] Additional parameters to include in template
      # @param capabilities [String] Additional capabilities to include in CloudFormation template
      # @param bucket_name [String] S3 Bucket name
      # @param bucket_encrypt [String] Include server side encryption 'AES256'

    def initialize(config, stack_name, template, parameters, capabilities, bucket_name, bucket_encrypt)

        @config = config
        @stack_name = stack_name
        @template = template
        @parameters = parameters
        @capabilities = capabilities
        @bucket_name = bucket_name
        @bucket_encrypt = bucket_encrypt
        @options = options

      end

      def execute

      end

    end

  end

end
