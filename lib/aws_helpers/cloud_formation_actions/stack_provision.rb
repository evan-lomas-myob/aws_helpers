module AwsHelpers

  module CloudFormationActions

    class StackProvision

      def initialize(config, stack_name, template, parameters, capabilities, bucket_name, bucket_encrypt)
        @config = config
        @stack_name = stack_name
        @template = template
        @parameters = parameters
        @capabilities = capabilities
        @bucket_name = bucket_name
        @bucket_encrypt = bucket_encrypt
      end

      def execute

      end

    end

  end

end
