module AwsHelpers

  module CloudFormation

    class StackProvision

      # @param config [AwsHelpers::CloudFormation::Config] config object with access methods to aws_cloud_formation_client and aws_s3_client
      # @param stack_name [String] Name given to the Stack
      # @param template [String] Name of the JSON template in the S3 bucket to use to create the stack
      # @param parameters [String] Optional parameters to include in template
      # @param capabilities [String] Optional capabilities to include in CloudFormation template
      # @param bucket_name [String] Optional S3 Bucket name - if not supplied, do not upload to S3 bucket
      # @param bucket_encrypt [Boolean] Optional server side encryption 'AES256'

    def initialize(config, stack_name, template, parameters, capabilities, bucket_name, bucket_encrypt)

        @config = config
        @stack_name = stack_name
        @template = template
        @parameters = parameters
        @capabilities = capabilities
        @bucket_name = bucket_name
        @bucket_encrypt = bucket_encrypt

      end

      def execute

      end

    end

  end

end
