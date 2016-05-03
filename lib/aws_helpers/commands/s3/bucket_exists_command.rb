require 'aws_helpers/commands/command'
require 'aws_helpers/utilities/polling'
require 'aws_helpers/commands/s3/bucket_helpers'

module AwsHelpers
  module Commands
    module S3
      class BucketExistsCommand < AwsHelpers::Commands::Command
        include AwsHelpers::Commands::S3::BucketHelpers

        def initialize(config, request)
          super(request)
          @client = config.aws_s3_client
        end

        def execute
          request.bucket_exists = check_bucket_exists(@client, request.bucket_name)
        end
      end
    end
  end
end
