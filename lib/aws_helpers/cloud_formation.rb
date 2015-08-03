require_relative 'client'
require_relative 'actions/cloud_formation/stack_provision'
require_relative 'actions/cloud_formation/stack_delete'
require_relative 'actions/cloud_formation/stack_modify_parameters'
require_relative 'actions/cloud_formation/stack_information'
require_relative 'actions/cloud_formation/stack_exists'

include AwsHelpers::Actions::CloudFormation

module AwsHelpers

  class CloudFormation < AwsHelpers::Client

    # CloudFormation utilities for creating, deleting and modifying templates
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    def initialize(options = {})
      super(options)
    end

    # @param stack_name [String] Name given to the Stack
    # @param template [String] Name of the JSON template in the S3 bucket to use to create the stack
    # @param parameters [String] Optional parameters to include in template
    # @param capabilities [String] Optional capabilities to include in CloudFormation template
    # @param bucket_name [String] Optional S3 Bucket name - if not supplied, do not upload to S3 bucket
    # @param bucket_encrypt [Boolean] Optional server side encryption 'AES256'
    def stack_provision(stack_name:, template:, parameters: nil, capabilities: nil, bucket_name: nil, bucket_encrypt: false)
      StackProvision.new(config, stack_name, template, parameters, capabilities, bucket_name, bucket_encrypt).execute
    end

    # @param stack_name [String] Name given to the Stack
    def stack_delete(stack_name:)
      StackDelete.new(config, stack_name).execute
    end

    # @param stack_name [String] Name given to the Stack
    # @param parameters [Array] List of parameters to modify in stack
    def stack_modify_parameters(stack_name:, parameters: [])
      StackModifyParameters.new(config, stack_name, parameters).execute
    end

    # @param stack_name [String] Name given to the Stack
    # @param info_field [String] Identify field to return (either "output" or "parameters")
    def stack_information(stack_name:, info_field: 'parameters')
      StackInformation.new(config, stack_name, info_field).execute
    end

    # @param stack_name [String] Name of the stack to check
    def stack_exists?(stack_name:)
      StackExists.new(config, stack_name).execute
    end

  end

end

