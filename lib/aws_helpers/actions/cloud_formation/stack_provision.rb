require 'aws_helpers/actions/s3/upload_template'
require 'aws_helpers/actions/cloud_formation/stack_rollback_complete'
require 'aws_helpers/actions/cloud_formation/stack_delete'
require 'aws_helpers/actions/cloud_formation/stack_create_request_builder'
require 'aws_helpers/actions/cloud_formation/stack_update'
require 'aws_helpers/actions/cloud_formation/stack_create'
require 'aws_helpers/utilities/polling_options'

include AwsHelpers::Actions::CloudFormation
include AwsHelpers::Actions::S3
include AwsHelpers::Utilities::PollingOptions

module AwsHelpers
  module Actions
    module CloudFormation
      class StackProvision
        def initialize(config, stack_name, template_json, options = {})
          @config = config
          @stack_name = stack_name
          @template_json = template_json
          @parameters = options[:parameters]
          @capabilities = options[:capabilities]
          @s3_bucket_name = options[:s3_bucket_name]
          @bucket_encrypt = options[:bucket_encrypt]
          @stdout = options[:stdout]
          @polling = create_options(@stdout, options[:polling])
        end

        def execute
          options = {stdout: @stdout}
          options.merge!({server_side_encryption: 'AES256'}) if @bucket_encrypt
          template_url = UploadTemplate.new(@config, @stack_name, @template_json, @s3_bucket_name, options).execute if @s3_bucket_name

          if StackExists.new(@config, @stack_name).execute && StackRollbackComplete.new(@config, @stack_name).execute
            StackDelete.new(@config, @stack_name, stdout: @stdout).execute
          end

          request = StackCreateRequestBuilder.new(@stack_name, template_url, @template_json, @parameters, @capabilities).execute
          StackExists.new(@config, @stack_name).execute ? update(request) : create(request)
          StackInformation.new(@config, @stack_name, 'outputs').execute
        end

        def update(request)
          StackUpdate.new(@config, @stack_name, request, @polling).execute
        end

        def create(request)
          StackCreate.new(@config, request, @polling).execute
        end
      end
    end
  end
end
