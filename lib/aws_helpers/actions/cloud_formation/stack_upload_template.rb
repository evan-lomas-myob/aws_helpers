require 'aws_helpers/actions/cloud_formation/s3_bucket_url'

module AwsHelpers
  module Actions
    module CloudFormation

      class StackUploadTemplate

        def initialize(config, stack_name, template_json, s3_bucket_name, bucket_encrypt, stdout = $stdout)
          @config = config
          @stack_name = stack_name
          @template_json = template_json
          @s3_bucket_name = s3_bucket_name
          @bucket_encrypt = bucket_encrypt
          @stdout = stdout
        end

        def execute
          s3_client = @config.aws_s3_client
          @stdout.puts "Uploading #{@stack_name} to S3 bucket #{@s3_bucket_name}"

          request = {
              bucket: @s3_bucket_name,
              key: @stack_name,
              body: @template_json,
          }
          request.merge!(server_side_encryption: 'AES256') if @bucket_encrypt
          s3_client.put_object(
              request
          )
          AwsHelpers::Actions::CloudFormation::S3BucketUrl.new(@config, @s3_bucket_name).execute
        end

      end

    end
  end
end