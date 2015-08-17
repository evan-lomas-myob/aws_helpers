require 'aws-sdk-resources'

module AwsHelpers
  module Actions
    module CloudFormation

      class S3TemplateUrl

        def initialize(config, s3_bucket_name)
          @config = config
          @s3_bucket_name = s3_bucket_name
        end

        def execute
          client = @config.aws_s3_client

          begin
            client.head_bucket(bucket: @s3_bucket_name)
            Aws::S3::Bucket.new(@s3_bucket_name, client: client).url
          rescue Aws::S3::Errors::NotFound
            false
          end

        end

      end
    end
  end
end