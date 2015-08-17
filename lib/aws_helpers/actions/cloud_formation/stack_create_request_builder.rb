module AwsHelpers
  module Actions
    module CloudFormation

      class StackCreateRequestBuilder

        def initialize(stack_name, s3_bucket_url, template_json, parameters, capabilities)
          @stack_name = stack_name
          @s3_bucket_url = s3_bucket_url
          @template_json = template_json
          @parameters = parameters
          @capabilities = capabilities
        end

        def execute
          request = { stack_name: @stack_name }
          if @s3_bucket_url
            request.merge!(template_url: @s3_bucket_url)
          else
            request.merge!(template_body: @template_json)
          end
          request.merge!(parameters: @parameters) if @parameters
          request.merge!(capabilities: @capabilities) if @capabilities
          request
        end


      end

    end
  end
end
