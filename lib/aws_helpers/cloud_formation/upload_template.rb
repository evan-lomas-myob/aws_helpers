require 'aws-sdk-core'

module AwsHelpers
  module CloudFormation
    class UploadTemplate

      def initialize(stack_name, template, bucket_name, bucket_encrypt, s3_client = Aws::S3::Client.new)
        @stack_name = stack_name
        @template = template
        @bucket_name = bucket_name
        @bucket_encrypt = bucket_encrypt
        @s3_client = s3_client
      end

      def execute
        if s3_template?
          puts "Uploading #{@stack_name} to S3 bucket #{@bucket_name} "
          request = {
            bucket: @bucket_name,
            key: @stack_name,
            body: @template,
          }
          request.merge!(server_side_encryption: 'AES256') if @bucket_encrypt
          @s3_client.put_object(
            request
          )
          "https://s3-#{s3_location}.amazonaws.com/#{@bucket_name}/#{@stack_name}"
        end
      end

      def s3_location
        resp = @s3_client.get_bucket_location(
          bucket: @bucket_name,
        )
        resp[:location_constraint]
      end

      def s3_template?
        !@bucket_name.nil?
      end

    end
  end
end