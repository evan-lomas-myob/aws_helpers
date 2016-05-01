require 'aws_helpers/commands/command'
require 'aws_helpers/utilities/polling'
require 'aws_helpers/commands/s3/bucket_helpers'

module AwsHelpers
  module Commands
    module S3
      class PollBucketExistsCommand < AwsHelpers::Commands::Command
        include AwsHelpers::Utilities::Polling
        include AwsHelpers::Commands::S3::BucketHelpers

        def initialize(config, request)
          super(request)
          @client = config.aws_s3_client
       end

        def execute
          return if request.bucket_exists
          bucket_name = request.bucket_name
          delay = request.bucket_polling.delay ||= 5
          max_attempts = request.bucket_polling.max_attempts ||= 3
          poll(delay, max_attempts) do
            stdout.puts "Waiting for S3 Bucket:#{bucket_name} to be created"
            request.bucket_exists = check_bucket_exists(@client, bucket_name)
            request.bucket_exists
          end
        end
      end
    end
  end
end
