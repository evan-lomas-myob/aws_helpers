require 'aws-sdk-resources'

module AwsHelpers
  module Actions
    module S3

      class S3Location

        def initialize(config, s3_bucket_name, stdout = $stdout)
          @config = config
          @s3_bucket_name = s3_bucket_name
          @stdout = stdout
        end

        def execute
          client = @config.aws_s3_client
          begin
            client.get_bucket_location(bucket: @s3_bucket_name).data
          rescue Aws::S3::Errors::NoSuchBucket
            @stdout.puts "Cannot find bucket named #{@s3_bucket_name}"
          end
        end

      end
    end
  end
end