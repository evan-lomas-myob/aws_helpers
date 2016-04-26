require 'aws-sdk-core'

module AwsHelpers
  module Actions
    module S3
      class Exists
        def initialize(config, bucket_name)
          @config = config
          @bucket_name = bucket_name
        end

        def execute
          client = @config.aws_s3_client
          client.list_buckets.buckets.select { |bucket| bucket.name == @bucket_name }.any?
        end
      end
    end
  end
end
