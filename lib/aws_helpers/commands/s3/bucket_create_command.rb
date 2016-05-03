require 'aws_helpers/commands/command'
require 'aws_helpers/commands/s3/bucket_helpers'

module AwsHelpers
  module Commands
    module S3
      class BucketCreateCommand < AwsHelpers::Commands::Command
        include AwsHelpers::Commands::S3::BucketHelpers

        def initialize(config, request)
          super(request)
          @client = config.aws_s3_client
        end

        def execute
          bucket_name = request.bucket_name
          return unless bucket_name && !request.bucket_exists

          bucket_acl = request.bucket_acl || 'private'
          @client.create_bucket(bucket: bucket_name, acl: bucket_acl)
          stdout.puts "Creating S3 Bucket #{bucket_name}"
        end
      end
    end
  end
end
