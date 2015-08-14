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
        end

        def execute
          AwsHelpers::Actions::CloudFormation::StackUploadTemplate.new(@config, @stack_name, @template_json, @s3_bucket_name, @bucket_encrypt, @stdout).execute if @s3_bucket_name
        end

      end

    end
  end
end