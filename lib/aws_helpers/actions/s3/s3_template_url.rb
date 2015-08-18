require 'aws-sdk-resources'
require 'aws_helpers/actions/s3/s3_exists'

module AwsHelpers
  module Actions
    module S3

      class S3TemplateUrl

        def initialize(config, s3_bucket_name)
          @config = config
          @s3_bucket_name = s3_bucket_name
        end

        def execute
          client = @config.aws_s3_client

          begin
            Aws::S3::Bucket.new(@s3_bucket_name, client: client).url if AwsHelpers::Actions::S3::S3Exists.new(@config, @s3_bucket_name).execute
          rescue Aws::S3::Errors::NotFound
            false
          end

        end

      end
    end
  end
end