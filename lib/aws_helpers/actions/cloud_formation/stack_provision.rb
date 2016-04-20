require 'aws_helpers/actions/s3/upload_template'
require 'aws_helpers/actions/cloud_formation/stack_rollback_complete'
require 'aws_helpers/actions/cloud_formation/stack_delete'
require 'aws_helpers/actions/cloud_formation/stack_create_request_builder'
require 'aws_helpers/actions/cloud_formation/stack_update'
require 'aws_helpers/actions/cloud_formation/stack_create'
require 'aws_helpers/utilities/polling_options'

module AwsHelpers
  module Actions
    module CloudFormation
      class StackProvision
        include AwsHelpers::Utilities::PollingOptions

        def initialize(config, stack_name, template_json, options = {})
          @config = config
          @stack_name = stack_name
          @template_json = template_json
          @parameters = options[:parameters]
          @capabilities = options[:capabilities] || %w(CAPABILITY_IAM) #SDK says so
          @s3_bucket_name = options[:s3_bucket_name]
          @bucket_encrypt = options[:bucket_encrypt]
          @stdout = options[:stdout]
          @bucket_options = create_options(@stdout, options[:bucket_polling]).tap { |tap| tap[:bucket_encrypt] = @bucket_encrypt }
          @stack_options = create_options(@stdout, options[:stack_polling])
        end

        def execute
          template_url = UploadTemplate.new(@config, @stack_name, @template_json, @s3_bucket_name, @bucket_options).execute if @s3_bucket_name

          if StackExists.new(@config, @stack_name).execute && StackRollbackComplete.new(@config, @stack_name).execute
            StackDelete.new(@config, @stack_name, @stack_options).execute
          end

          request = StackCreateRequestBuilder.new(@stack_name, template_url, @template_json, @parameters, @capabilities).execute
          StackExists.new(@config, @stack_name).execute ? update(request) : create(request)
          StackInformation.new(@config, @stack_name, 'outputs').execute
        end

        def update(request)
          StackUpdate.new(@config, request, @stack_options).execute
        end

        def create(request)
          StackCreate.new(@config, request, @stack_options).execute
        end
      end
    end
  end
end
