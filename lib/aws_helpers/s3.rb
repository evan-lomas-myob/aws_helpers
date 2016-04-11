require_relative 'client'
require_relative 'actions/s3/create'
require_relative 'actions/s3/exists'
require_relative 'actions/s3/put_object'

include AwsHelpers::Actions::S3

module AwsHelpers
  class S3 < AwsHelpers::Client
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
    # @param s3_bucket_name [String] The S3 bucket name to create
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [String] :acl Override the acl to apply to the bucket
    # @option options [IO] :stdout Override $stdout when logging output
    #
    # @example Create an s3 bucket
    #    AwsHelpers::S3.new.create('Test-S3-Bucket')
    #
    # @return [nil]
    #
    def create(s3_bucket_name, options = {})
      S3Create.new(config, s3_bucket_name, options).execute
    end

    # Check if an S3 bucket exists
    #
    # @param s3_bucket_name [String] The S3 bucket name to check
    #
    # @example Check if this S3 bucket exists
    #   AwsHelpers::S3.new.exists('Test-S3-Bucket')
    #
    # @return [Boolean]
    #
    def exists?(s3_bucket_name)
      S3Exists.new(config, s3_bucket_name).execute
    end

    # Puts an object in an existing S3 bucket
    #
    # @param s3_bucket_name [String] The S3 bucket name to create the object in
    # @param key_name [String] The name of the object in the S3 bucket
    # @param body [String] The object content body
    # @option options [IO] :stdout Override $stdout when logging output
    #
    # @example List the instances associated with an ASG
    #   AwsHelpers::S3.new.put_object('Test-S3-Bucket','S3_Object_Name','File Contents')
    #
    # @return [nil]
    #
    def put_object(s3_bucket_name, key_name, body, options = {})
      S3PutObject.new(config, s3_bucket_name, key_name, body, options).execute
    end
  end
end
