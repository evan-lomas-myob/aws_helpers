require_relative 'client'
require_relative 'actions/s3/create'
require_relative 'actions/s3/exists'

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
      Create.new(config, s3_bucket_name, options).execute
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
      Exists.new(config, s3_bucket_name).execute
    end

  end
end
