module AwsHelpers
  module Actions
    module S3
      class S3PutObject
        def initialize(config, bucket_name, key_name, body, options = {})
          @config = config
          @bucket = bucket_name
          @key = key_name
          @body = body
          @stdout = options[:stdout] || $stdout
        end

        def execute
          client = @config.aws_s3_client
          @stdout.puts "Create S3 Object #{@key} in #{@bucket}"
          client.put_object(bucket: @bucket, key: @key, body: @body)
        end
      end
    end
  end
end
