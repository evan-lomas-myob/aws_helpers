require 'aws_helpers/actions/cloud_formation/stack_upload_template'
require 'aws_helpers/actions/cloud_formation/stack_rollback_complete'
require 'aws_helpers/actions/cloud_formation/stack_delete'
require 'aws_helpers/actions/cloud_formation/stack_create_request_builder'
require 'aws_helpers/actions/cloud_formation/stack_update'
require 'aws_helpers/actions/cloud_formation/stack_create'

include AwsHelpers::Actions::CloudFormation

module AwsHelpers
  module Actions
    module CloudFormation

      class StackProvision

        def initialize(config, stack_name, template_json, parameters, capabilities, s3_bucket_name, bucket_encrypt, stdout = $stdout)
          @config = config
          @stack_name = stack_name
          @template_json = template_json
          @parameters = parameters
          @capabilities = capabilities
          @s3_bucket_name = s3_bucket_name
          @bucket_encrypt = bucket_encrypt
          @stdout = stdout

          @max_attempts = 10
          @delay = 5

        end

        def execute
          template_url = StackUploadTemplate.new(@config, @stack_name, @template_json, @s3_bucket_name, @bucket_encrypt, @stdout).execute if @s3_bucket_name

          if StackExists.new(@config, @stack_name).execute && StackRollbackComplete.new(@config, @stack_name).execute
            StackDelete.new(@config, @stack_name, @stdout).execute
          end

          request = StackCreateRequestBuilder.new(@stack_name, template_url, @template_json, @parameters, @capabilities).execute
          StackExists.new(@config, @stack_name).execute ? update(request) : create(request)
          StackInformation.new(@config, @stack_name, 'outputs').execute
        end

        def update(request)
          StackUpdate.new(@config, @stack_name, request, @max_attempts, @delay, @stdout).execute
        end

        def create(request)
          StackCreate.new(@config, @stack_name, request, @max_attempts, @delay, @stdout).execute
        end

      end

    end
  end
end