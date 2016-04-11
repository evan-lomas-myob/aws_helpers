module AwsHelpers
  module Actions
    module S3
      class S3Create
        def initialize(config, s3_bucket_name, options = {})
          @config = config
          @s3_bucket_name = s3_bucket_name
          @acl = options[:acl] || 'private'
          @stdout = options[:stdout] || $stdout
        end

        def execute
          client = @config.aws_s3_client
          if AwsHelpers::Actions::S3::S3Exists.new(@config, @s3_bucket_name).execute
            @stdout.puts("#{@s3_bucket_name} already exists")
          else
            client.create_bucket(acl: @acl, bucket: @s3_bucket_name)
            client.wait_until(:bucket_exists, bucket: @s3_bucket_name)
            @stdout.puts "Created S3 Bucket #{@s3_bucket_name}"
          end
        end
      end
    end
  end
end
