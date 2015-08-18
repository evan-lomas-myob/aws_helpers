require 'aws-sdk-resources'

module AwsHelpers
  module Actions
    module S3

      class S3Create

        def initialize(config, s3_bucket_name, stdout = $stdout)
          @config = config
          @s3_bucket_name = s3_bucket_name
          @stdout = stdout
        end

        def execute
          client = @config.aws_s3_client
          client.create_bucket(acl: 'private', bucket: @s3_bucket_name )
          client.wait_until(:bucket_exists, bucket: @s3_bucket_name)
          @stdout.puts "Created S3 Bucket #{@s3_bucket_name}"
        end

      end
    end
  end
end