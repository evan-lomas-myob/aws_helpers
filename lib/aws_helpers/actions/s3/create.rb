require_relative 'poll_bucket_exists'

module AwsHelpers
  module Actions
    module S3
      class Create
        def initialize(config, bucket_name, options = {})
          @config = config
          @bucket_name = bucket_name
          @options = options
          @acl = options[:acl] || 'private'
          @stdout = options[:stdout] || $stdout
        end

        def execute
          client = @config.aws_s3_client
          if AwsHelpers::Actions::S3::Exists.new(@config, @bucket_name).execute
            @stdout.puts("#{@bucket_name} already exists")
          else
            client.create_bucket(acl: @acl, bucket: @bucket_name)
            PollBucketExists.new(@config, @bucket_name, @options)
            @stdout.puts "Created S3 Bucket #{@bucket_name}"
          end
        end
      end
    end
  end
end
