require 'aws_helpers/actions/s3/exists'
require 'aws_helpers/actions/s3/create'
require 'aws_helpers/actions/s3/template_url'

module AwsHelpers
  module Actions
    module S3
      class UploadTemplate
        def initialize(config, stack_name, template_json, s3_bucket_name, options) # rubocop:disable Style/ParameterLists
          @config = config
          @client = config.aws_s3_client
          @stack_name = stack_name
          @s3_bucket_name = s3_bucket_name
          @template_json = template_json
          @options = options
          @bucket_encrypt = options[:bucket_encrypt] || false
          @stdout = options[:stdout] || $stdout
        end

        def execute
          request = {
              bucket: @s3_bucket_name,
              key: @stack_name,
              body: @template_json
          }
          request.merge!({server_side_encryption: 'AES256'}) if @bucket_encrypt
          AwsHelpers::Actions::S3::Create.new(@config, @s3_bucket_name, @options).execute
          @stdout.puts "Uploading #{@stack_name} to S3 bucket #{@s3_bucket_name}"
          @client.put_object(request)
          AwsHelpers::Actions::S3::TemplateUrl.new(@config, @s3_bucket_name).execute
        end
      end
    end
  end
end
