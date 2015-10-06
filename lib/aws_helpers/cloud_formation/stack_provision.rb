require_relative 'describe_stack'
require_relative 'stack_exists'
require_relative 'stack_status'
require_relative 'stack_outputs'
require_relative 'stack_progress'
require_relative 'stack_create'
require_relative 'stack_update'
require_relative 'stack_delete'
require_relative 'upload_template'

module AwsHelpers
  module CloudFormation
    class StackProvision

      def initialize(cloud_formation_client, s3_client, stack_name, template,  options = {})
        @cloud_formation_client = cloud_formation_client
        @s3_client = s3_client
        @stack_name = stack_name
        @template = template
        @parameters = options[:parameters]
        @capabilities = options[:capabilities]
        @upload_template = UploadTemplate.new(s3_client, stack_name, template, options[:bucket_name], options[:bucket_encrypt])
      end

      def execute
        template_url = @upload_template.execute
        if create_rollback?
          delete
        end
        exists? ? update(template_url) : create(template_url)
        StackOutputs.new(@cloud_formation_client, @stack_name).execute
      end

      private

      def delete
        StackDelete.new(@cloud_formation_client, @stack_name).execute
      end

      def create(template_url)
        StackCreate.new(@cloud_formation_client, request(template_url)).execute
      end

      def update(template_url)
        StackUpdate.new(@cloud_formation_client, request(template_url)).execute
      end

      def exists?
        StackExists.new(@cloud_formation_client, @stack_name).execute
      end

      def create_rollback?
        DescribeStack.new(@cloud_formation_client, @stack_name).execute[:stack_status] == ROLLBACK_COMPLETE if exists?
      end

      def request(template_url)
        request = { stack_name: @stack_name }
        if template_url
          request.merge!(template_url: template_url)
        else
          request.merge!(template_body: @template)
        end
        request.merge!(parameters: @parameters) if @parameters
        request.merge!(capabilities: @capabilities) if @capabilities
        request
      end

    end
  end
end