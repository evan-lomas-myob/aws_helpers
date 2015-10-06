require_relative 'client'
require_relative 'actions/cloud_formation/stack_provision'
require_relative 'actions/cloud_formation/stack_delete'
require_relative 'actions/cloud_formation/stack_modify_parameters'
require_relative 'actions/cloud_formation/stack_information'
require_relative 'actions/cloud_formation/stack_exists'
require_relative 'actions/cloud_formation/stack_resources'
require_relative 'actions/cloud_formation/stack_named_resource'

module AwsHelpers

  class CloudFormation < AwsHelpers::Client

    # CloudFormation utilities for creating, deleting and modifying templates
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    def initialize(options = {})
      super(options)
    end

    # Create a stack from scratch using a pre-defined template.
    # Template reference: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html
    # @param stack_name [String] Name given to the Stack
    # @param template [String] The cloud formation template
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [Array] :parameters Parameters to include in template e.g. [{ parameter_key: 'key', parameter_value: 'value' }]
    # @option options [Array] :capabilities Capabilities required when provisioning the stack e.g ['CAPABILITY_IAM']
    # @option options [String] :bucket_name Upload to an S3 bucket before provisioning
    # @option options [Boolean] :bucket_encrypt server side encryption on the upload bucket, 'AES256'
    # @option options [IO] :stdout Override $stdout when logging output
    # @option options [Hash{Symbol => Integer}] :polling stack pooling attempts and delay
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 40,
    #     :delay => 15 # seconds
    #   }
    #   ```
    def stack_provision(stack_name, template, options = {})
      AwsHelpers::Actions::CloudFormation::StackProvision.new(config, stack_name, template, options).execute
    end

    # Delete an existing stack by providing the stack name
    # @param stack_name [String] Name given to the Stack
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout Override $stdout when logging output
    def stack_delete(stack_name, options = {})
      AwsHelpers::Actions::CloudFormation::StackDelete.new(config, stack_name, options).execute
    end

    # Modify the parameters of an existing stack.
    # The parameter names must be known in advance to be included in the parameters array
    #
    # @param stack_name [String] Name given to the Stack
    # @param parameters [Array] List of parameters to modify in stack e.g. [{ parameter_key: 'key', parameter_value: 'value' }]
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout Override $stdout when logging output
    # @option options [Hash{Symbol => Integer}] :polling Override update stack polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 40,
    #     :delay => 15 # seconds
    #   }
    #   ```
    def stack_modify_parameters(stack_name, parameters, options = {})
      AwsHelpers::Actions::CloudFormation::StackModifyParameters.new(config, stack_name, parameters, options).execute
    end

    # @param stack_name [String] Name given to the Stack
    # @return [Array] The list of parameters defined for the Stack
    def stack_parameters(stack_name)
      AwsHelpers::Actions::CloudFormation::StackInformation.new(config, stack_name, 'parameters').execute
    end

    # @param stack_name [String] Name given to the Stack
    # @return [Array] The list of outputs defined for the Stack
    def stack_outputs(stack_name)
      AwsHelpers::Actions::CloudFormation::StackInformation.new(config, stack_name, 'output').execute
    end

    # @param stack_name [String] Name of the stack to check
    # @return [Boolean] True if the stack exists
    def stack_exists?(stack_name)
      AwsHelpers::Actions::CloudFormation::StackExists.new(config, stack_name).execute
    end

    # @param stack_name [String] Name given to the Stack
    # @return [Array] The list of resources defined for the Stack
    def stack_resources(stack_name)
      AwsHelpers::Actions::CloudFormation::StackResources.new(config, stack_name).execute
    end

    # @param stack_name [String] Name given to the Stack
    # @param resource_id [String] The Logical Resource Identifier
    # @return [Array] The list of resources defined for the Stack
    def stack_named_resource(stack_name, resource_id)
      AwsHelpers::Actions::CloudFormation::StackNamedResource.new(config, stack_name, resource_id).execute
    end

  end

end

