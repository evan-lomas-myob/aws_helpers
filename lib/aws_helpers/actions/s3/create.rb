require_relative 'poll_bucket_exists'

module AwsHelpers
  module Actions
    module S3
      class Create
        def initialize(config, s3_bucket_name, options = {})
          @config = config
          @s3_bucket_name = s3_bucket_name
          @options = options
          @acl = options[:acl] || 'private'
          @stdout = options[:stdout] || $stdout
        end

        def execute
          client = @config.aws_s3_client
          if AwsHelpers::Actions::S3::Exists.new(@config, @s3_bucket_name).execute
            @stdout.puts("#{@s3_bucket_name} already exists")
          else
            client.create_bucket(acl: @acl, bucket: @s3_bucket_name)
            PollBucketExists.new(@config, @s3_bucket_name, @options)
            @stdout.puts "Created S3 Bucket #{@s3_bucket_name}"
          end
        end
      end
    end
  end
end
