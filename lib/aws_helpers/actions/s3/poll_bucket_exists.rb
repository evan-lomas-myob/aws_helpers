require 'aws-sdk-core'
require 'aws_helpers/utilities/polling'
require_relative 'exists'

module AwsHelpers
  module Actions
    module S3
      class PollBucketExists
        include AwsHelpers::Utilities::Polling

        def initialize(config, s3_bucket_name, options = {})
          @config = config
          @s3_bucket_name = s3_bucket_name
          @stdout = options[:stdout] || $stdout
          @delay = options[:delay] || 5
          @max_attempts = options[:max_attempts] || 3
        end

        def execute
          poll(@delay, @max_attempts) do
            @stdout.puts "Waiting for S3 Bucket:#{@s3_bucket_name} to be created"
            AwsHelpers::Actions::S3::Exists.new(@config, @s3_bucket_name).execute
          end
        end
      end
    end
  end
end