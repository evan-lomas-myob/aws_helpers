require_relative 'client'
require_relative 'actions/cloud_formation/stack_provision'
require_relative 'actions/cloud_formation/stack_delete'
require_relative 'actions/cloud_formation/stack_modify_parameters'
require_relative 'actions/cloud_formation/stack_information'
require_relative 'actions/cloud_formation/stack_exists'
require_relative 'actions/cloud_formation/stack_resources'
require_relative 'actions/cloud_formation/stack_named_resource'
require_relative 'utilities/polling_options'

module AwsHelpers
  class CloudFormation < AwsHelpers::Client
    include AwsHelpers::Utilities::PollingOptions

    # CloudFormation utilities for creating, deleting and modifying templates
    #
    # @param options [Hash] Optional arguments to include when calling the AWS SDK. These arguments will
    #   affect all clients used by this helper. See the {http://docs.aws.amazon.com/sdkforruby/api/Aws/CloudFormation/Client.html#initialize-instance_method AWS documentation}
    #   for a list of CloudFormation-specific client options.
    #
    # @example Initialise CloudFormation Client
    #    aws = AwsHelpers::CloudFormation.new
    #
    # @return [AwsHelpers::CloudFormation]
    #
    def initialize(options = {})
      super(options)
    end

    # Create a stack from scratch using a pre-defined template.
    # Template reference: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html
    #
    # @param stack_name [String] Name given to the Stack
    # @param template [String] The cloud formation json template
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [Array] :parameters Parameters to include in template e.g. [{ parameter_key: 'key', parameter_value: 'value' }]
    # @option options [Array] :capabilities Capabilities required when provisioning the stack e.g ['CAPABILITY_IAM']
    # @option options [String] :bucket_name If the template body exceeds 51200 bytes in size,
    #   you must specify an S3 bucket to upload the template to first
    # @option options [Boolean] :bucket_encrypt Encryption type to use on the upload bucket; defaults to 'AES256'
    # @option options [IO] :stdout Override $stdout when logging output
    # @option options [Hash{Symbol => Integer}] :bucket_polling stack polling attempts and delay
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 3,
    #     :delay => 5 # seconds
    #   }
    #   ```
    #
    # @option options [Hash{Symbol => Integer}] :stack_polling stack polling attempts and delay
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 40,
    #     :delay => 30 # seconds
    #   }
    #   ```
    #
    # @example Create a basic cloudformation stack with a single instance
    #   AwsHelpers::CloudFormation.new.stack_provision(
    #     'TestStackName','{
    #       "Resources": {
    #         "TestInstance": {
    #           "Type" : "AWS::EC2::Instance",
    #           "Properties": {
    #             "ImageId": "ami-530b2e30"
    #           }
    #         }
    #       },
    #       "Parameters" : {
    #         "ImageId": {
    #           "Type" : "AWS::EC2::Image::Id",
    #           "Default" : "ami-530b2e30"
    #         }
    #       },
    #       "Outputs": {
    #         "InstanceId" : {
    #           "Description" : "InstanceId of the EC2 instance",
    #           "Value" : { "Ref" : "TestInstance" }
    #         }
    #       }
    #     }'
    #   )
    #
    # @return [Array]
    #
    def stack_provision(stack_name, template, options = {})
      AwsHelpers::Actions::CloudFormation::StackProvision.new(config, stack_name, template, options).execute
    end

    # Delete an existing stack by providing the stack name
    #
    # @param stack_name [String] Name given to the Stack
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout Override $stdout when logging output
    # @option options [Hash{Symbol => Integer}] :stack_polling Override update stack polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 40,
    #     :delay => 30 # seconds
    #   }
    #   ```
    #
    #
    # @example Remove the names stack from AWS
    #   AwsHelpers::CloudFormation.new.stack_delete('TestStackName')
    #
    # @return [nil]
    #
    def stack_delete(stack_name, options = {})
      AwsHelpers::Actions::CloudFormation::StackDelete.new(config, stack_name, create_options(options[:stdout], options[:stack_polling])).execute
    end

    # Modify the parameters of an existing stack.
    #
    # @param stack_name [String] Name given to the Stack
    # @param parameters [Array] List of parameters to modify in stack e.g. [{ parameter_key: 'key', parameter_value: 'value' }]
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout Override $stdout when logging output
    # @option options [Hash{Symbol => Integer}] :stack_polling Override update stack polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 40,
    #     :delay => 30 # seconds
    #   }
    #   ```
    #
    # @example
    #   AwsHelpers::CloudFormation.new.stack_modify_parameters(
    #     'TestStackName',
    #     [ { parameter_key: 'InstanceImageId', parameter_value: 'ami-123ab123' }]
    #   )
    #
    # @return
    #
    def stack_modify_parameters(stack_name, parameters, options = {})
      AwsHelpers::Actions::CloudFormation::StackModifyParameters.new(config, stack_name, parameters, create_options(options[:stdout], options[:stack_polling])).execute
    end

    # Return the parameters of a cloudformation stack
    #
    # @param stack_name [String] Name given to the Stack
    #
    # @example Return the stack parameters
    #  AwsHelpers::CloudFormation.new.stack_parameters('TestStackName')
    #
    # @return [Array[struct]] Array[{http://docs.aws.amazon.com/sdkforruby/api/Aws/CloudFormation/Types/Parameter.html Parameter}]
    #
    def stack_parameters(stack_name)
      AwsHelpers::Actions::CloudFormation::StackInformation.new(config, stack_name, 'parameters').execute
    end

    # Return the outputs of a cloudformation stack
    #
    # @param stack_name [String] Name given to the Stack
    #
    # @example Return the stack outputs
    #  AwsHelpers::CloudFormation.new.stack_outputs('TestStackName')
    #
    # @return [Array[struct]] Array[{http://docs.aws.amazon.com/sdkforruby/api/Aws/CloudFormation/Types/Output.html Output}]
    #
    def stack_outputs(stack_name)
      AwsHelpers::Actions::CloudFormation::StackInformation.new(config, stack_name, 'outputs').execute
    end

    # Return true or false if the stack exists or not
    #
    # @param stack_name [String] Name of the stack to check
    #
    # @example Checks if the stack exists
    #  AwsHelpers::CloudFormation.new.stack_exists?('TestStackName')
    #
    # @return [Boolean] True if the stack exists and false if it does not
    #
    def stack_exists?(stack_name)
      AwsHelpers::Actions::CloudFormation::StackExists.new(config, stack_name).execute
    end

    # Return all resources associated with the stack
    #
    # @param stack_name [String] Name given to the Stack
    #
    # @example Return an array of resources (for a stack to be created, there must at least be 1)
    #  AwsHelpers::CloudFormation.new.stack_resources('TestStackName')
    #
    # @return [Array[struct]] Array[{http://docs.aws.amazon.com/sdkforruby/api/Aws/CloudFormation/Types/StackResource.html StackResource}]
    #
    def stack_resources(stack_name)
      AwsHelpers::Actions::CloudFormation::StackResources.new(config, stack_name).execute
    end

    # Return a resource associated with the stack identified by name
    #
    # @param stack_name [String] Name of the stack
    # @param resource_id [String] The logical name of the resource as specified in the stack template.
    #
    # @example Return a named resource
    #  AwsHelpers::CloudFormation.new.stack_named_resource('TestStackName','TestInstance')
    #
    # @return [struct] Struct of type {http://docs.aws.amazon.com/sdkforruby/api/Aws/CloudFormation/Types/StackResourceDetail.html StackResourceDetail}
    #
    def stack_named_resource(stack_name, resource_id)
      AwsHelpers::Actions::CloudFormation::StackNamedResource.new(config, stack_name, resource_id).execute
    end
  end
end
