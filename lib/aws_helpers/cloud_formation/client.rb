require 'aws-sdk-core'
require_relative '../common/client'
require_relative 'config'
require_relative 'stack_create'
require_relative 'stack_delete'
require_relative 'stack_modify_parameters'
require_relative 'stack_information'
require_relative 'stack_exists'

module AwsHelpers

  module CloudFormation

    class Client < AwsHelpers::Common::Client

      # CloudFormation utilities for creating, deleting and modifying templates
      # @param options [Hash] Optional Arguments to include when calling the AWS SDK

      def initialize(options = {})
        super(AwsHelpers::CloudFormation::Config.new(options))
      end

      # @param stack_name [String] Name given to the Stack
      # @param template [String] Name of the JSON template in the S3 bucket to use to create the stack
      # @param parameters [String] Additional parameters to include in template
      # @param capabilities [String] Additional capabilities to include in CloudFormation template
      # @param bucket_name [String] S3 Bucket name
      # @param bucket_encrypt [String] Include server side encryption 'AES256'

      def stack_create(stack_name:, template:, parameters:, capabilities:, bucket_name:, bucket_encrypt:)
        AwsHelpers::CloudFormation::StackCreate.new(config, stack_name, template, parameters, capabilities, bucket_name, bucket_encrypt).execute
      end

      # @param stack_name [String] Name given to the Stack

      def stack_delete(stack_name:)
        AwsHelpers::CloudFormation::StackDelete.new(config, stack_name).execute
      end

      # @param stack_name [String] Name given to the Stack
      # @param parameters [Array] List of parameters to modify in stack

      def stack_modify_parameters(stack_name:, parameters: [])
        AwsHelpers::CloudFormation::StackModifyParameters.new(config, stack_name, parameters).execute
      end

      # @param stack_name [String] Name given to the Stack
      # @param info_field [String] Identify field to return (either "output" or "parameters")

      def stack_information(stack_name:, info_field: 'parameters')
        AwsHelpers::CloudFormation::StackInformation.new(config, stack_name, info_field).execute
      end

      # @param stack_name [String] Name of the stack to check

      def stack_exists?(stack_name:)
        AwsHelpers::CloudFormation::StackExists.new(config, stack_name).execute
      end

    end

  end

end

