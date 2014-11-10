require_relative 'stack_status'
require_relative 'error_events'
require 'aws-sdk-core'

module AwsHelpers
  module CloudFormation

    class Stack

      def initialize(stack_name, template, options = {})
        @client = Aws::CloudFormation::Client.new
        @stack_name = stack_name
        @template = template
        @bucket_name = options[:bucket_name]
        @bucket_encrypt= options[:bucket_encrypt]
        @parameters = options[:parameters]
        @capabilities = options[:capabilities]
      end

      def provision
        upload_to_s3
        if create_rollback?
          delete
        end
        exists? ? update : create
        AwsHelpers::CloudFormation::Stack.outputs(@stack_name, @client)
      end

      def self.outputs(stack_name, client = Aws::CloudFormation::Client.new)
        describe_stack(stack_name, client)[:outputs].map { |output| output.to_h }
      end

      def self.exists?(stack_name, client = Aws::CloudFormation::Client.new)
        begin
          !describe_stack(stack_name, client).nil?
        rescue Aws::CloudFormation::Errors::ValidationError => validation_error
          if validation_error.message == "Stack:#{stack_name} does not exist"
            false
          else
            raise validation_error
          end
        end
      end

      def describe_stack
        AwsHelpers::CloudFormation::Stack.describe_stack(@stack_name, @client)
      end

      def describe_stack_events(next_token = nil)
        @client.describe_stack_events(stack_name: @stack_name, next_token: next_token)
      end

      private

      def upload_to_s3
        if s3_template?
          puts "Uploading #{@stack_name} to S3 bucket #{@bucket_name} "
          s3 = Aws::S3::Client.new
          request = {
            bucket: @bucket_name,
            key: @stack_name,
            body: @template,
          }
          request.merge!(server_side_encryption: "AES256") if @bucket_encrypt

          s3.put_object(
            request
          )
        end
      end

      def s3_location
        client = Aws::S3::Client.new
        resp = client.get_bucket_location(
          bucket: @bucket_name,
        )
        resp[:location_constraint]
      end

      def s3_template?
        !@bucket_name.nil?
      end

      def self.describe_stack(stack_name, client)
        client.describe_stacks(stack_name: stack_name)[:stacks].first
      end

      def exists?
        AwsHelpers::CloudFormation::Stack.exists?(@stack_name, @client)
      end

      def status
        describe_stack[:stack_status] if exists?
      end

      def create_rollback?
        describe_stack[:stack_status] == ROLLBACK_COMPLETE if exists?
      end

      def create
        puts "Creating #{@stack_name}"
        @client.create_stack(create_request)

        until describe_stack
          sleep 5
        end

        check_status
      end

      def check_status
        status = StackStatus.new(self)
        status.poll
        ErrorEvents.new(self).report
        status.check_failure
      end

      def update
        puts "Updating #{@stack_name}"
        begin
          @client.update_stack(create_request)
          check_status
        rescue Aws::CloudFormation::Errors::ValidationError => validation_error
          if validation_error.message == 'No updates are to be performed.'
            puts "No updates to perform for #{@stack_name}."
          else
            raise validation_error
          end
        end

      end

      def delete
        puts "Deleting #{@stack_name}"
        @client.delete_stack(
          stack_name: @stack_name
        )
        while exists?
          sleep 5
        end

      end

      def create_request
        request = { stack_name: @stack_name }
        if s3_template?
          request.merge!(template_url: "https://s3-#{s3_location}.amazonaws.com/#{@bucket_name}/#{@stack_name}")
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