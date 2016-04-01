module AwsHelpers
  module Actions
    module CloudFormation
      class StackCreateRequestBuilder
        def initialize(stack_name, s3_bucket_url, template_json, parameters, capabilities)
          @stack_name = stack_name
          @s3_bucket_url = s3_bucket_url
          @template_json = template_json
          @parameters = parameters
          @capabilities = capabilities || ['CAPABILITY_IAM']
        end

        def execute
          request = { stack_name: @stack_name }
          if @s3_bucket_url
            request[:template_url] = @s3_bucket_url
          else
            request[:template_body] = @template_json
          end
          request[:parameters] = @parameters if @parameters
          request[:capabilities] = @capabilities if @capabilities
          request
        end
      end
    end
  end
end
