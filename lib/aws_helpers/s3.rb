require 'aws_helpers/client'
require 'aws_helpers/requests/polling_request'
require 'aws_helpers/requests/s3/bucket_exists_request'
require 'aws_helpers/requests/s3/bucket_create_request'
require 'aws_helpers/directors/s3/bucket_exists_director'
require 'aws_helpers/directors/s3/bucket_create_director'

module AwsHelpers
  class S3 < AwsHelpers::Client
    extend Gem::Deprecate
    # Utilities for creating, checking and uploading to S3 buckets.
    #
    # @param options [Hash] Optional arguments to include when calling the AWS SDK.
    #
    # @example Initialise S3 Client
    #    client = AwsHelpers::S3.new
    #
    # @return [AwsHelpers::S3]
    #
    def initialize(options = {})
      super(options)
    end

    # Create an S3 bucket if it doesn't exist
    #
    # @param name [String] The bucket name to create
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout Override $stdout when logging output
    # @option options [String] :acl Override the acl to apply to the bucket
    # @option options [Hash{Symbol => Integer}] :bucket_polling stack polling attempts and delay
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 3,
    #     :delay => 5 # seconds
    #   }
    #   ```
    #
    # @example Create an s3 bucket
    #    AwsHelpers::S3.new.bucket_create('Test-S3-Bucket')
    #
    # @return [nil]
    #
    def bucket_create(name, options = {})
      request = AwsHelpers::Requests::S3::BucketCreateRequest.new(
          stdout: options[:stdout],
          bucket_name: name,
          bucket_acl: options[:acl],
          bucket_polling: AwsHelpers::Requests::PollingRequest.new(options[:bucket_polling]))
      AwsHelpers::Directors::S3::BucketCreateDirector.new(config).create(request)
    end

    alias_method :create, :bucket_create
    deprecate :create, :bucket_create, 2016, 6

    # Check if an S3 bucket exists
    #
    # @param name [String] The bucket name to check
    #
    # @example Check if this S3 bucket exists
    #   AwsHelpers::S3.new.bucket_exists?('Test-S3-Bucket')
    #
    # @return [Boolean]
    #
    def bucket_exists?(name)
      request = AwsHelpers::Requests::S3::BucketExistsRequest.new(
          bucket_name: name)
      AwsHelpers::Directors::S3::BucketExistsDirector.new(config).exists?(request)
    end

    alias_method :exists?, :bucket_exists?
    deprecate :exists?, :bucket_exists?, 2016, 6
  end
end
