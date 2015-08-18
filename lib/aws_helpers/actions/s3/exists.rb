require 'aws-sdk-resources'

module AwsHelpers
  module Actions
    module S3

      class S3Exists

        def initialize(config, s3_bucket_name)
          @config = config
          @s3_bucket_name = s3_bucket_name
        end

        def execute
          client = @config.aws_s3_client

          begin
            client.head_bucket(bucket: @s3_bucket_name)
            true
          rescue Aws::S3::Errors::NotFound
            false
          end

        end

      end
    end
  end
end