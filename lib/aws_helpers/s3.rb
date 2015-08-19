require_relative 'client'
require_relative 'actions/s3/create'
require_relative 'actions/s3/exists'
require_relative 'actions/s3/template_url'
require_relative 'actions/s3/location'
require_relative 'actions/s3/upload_template'

module AwsHelpers

  class S3 < AwsHelpers::Client

    # Utilities for S3 creation and uploading
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    # @return [AwsHelpers::Config] A Config object with options initialized
    def initialize(options = {})
      super(options)
    end

    # @param s3_bucket_name [String] Name given to the S3 Bucket to create
    def s3_create(s3_bucket_name:)
      AwsHelpers::Actions::S3::S3Create.new(config, s3_bucket_name).execute
    end

    # @param s3_bucket_name [String] Name given to the S3 Bucket
    def s3_exists?(s3_bucket_name:)
      AwsHelpers::Actions::S3::S3Exists.new(config, s3_bucket_name).execute
    end

    # @param s3_bucket_name [String] Name given to the S3 Bucket
    def s3_url(s3_bucket_name:)
      AwsHelpers::Actions::S3::S3TemplateUrl.new(config, s3_bucket_name).execute
    end

    # @param s3_bucket_name [String] Name given to the S3 Bucket
    def s3_location(s3_bucket_name:)
      AwsHelpers::Actions::S3::S3Location.new(config, s3_bucket_name).execute
    end

    # @param stack_name [String] Name given to the stack
    # @param template_json [String] JSON Template as the request body
    # @param s3_bucket_name [String] Name given to the S3 Bucket
    # @param bucket_encrypt [Boolean] Encrypt to S3 content

    def upload_stack_template(stack_name:, template_json:, s3_bucket_name:, bucket_encrypt:)
      AwsHelpers::Actions::S3::S3UploadTemplate.new(config, stack_name, template_json, s3_bucket_name, bucket_encrypt).execute
    end

  end

end


