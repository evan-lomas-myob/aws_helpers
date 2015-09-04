require 'aws-sdk-resources'
require 'aws_helpers/actions/s3/exists'

module AwsHelpers
  module Actions
    module S3

      class S3BucketWebsite

        def initialize(config, s3_bucket_name, website_configuration, stdout = $stdout)
          @config = config
          @s3_bucket_name = s3_bucket_name
          @website_configuration = website_configuration
          @stdout = stdout
        end

        def execute

          options = {bucket: @s3_bucket_name, website_configuration: @website_configuration}
          client = @config.aws_s3_client

          begin
            client.put_bucket_website(options) if AwsHelpers::Actions::S3::S3Exists.new(@config, @s3_bucket_name).execute
          rescue Aws::S3::Errors::NotFound
            @stdout.puts "The S3 Bucket #{@s3_bucket_name} does not exist"
          end

        end

      end

    end
  end
end