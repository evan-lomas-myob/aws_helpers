require_relative 'client'
require_relative 'actions/cloud_formation/stack_provision'
require_relative 'actions/cloud_formation/stack_delete'
require_relative 'actions/cloud_formation/stack_modify_parameters'
require_relative 'actions/cloud_formation/stack_information'
require_relative 'actions/cloud_formation/stack_exists'
require_relative 'actions/cloud_formation/stack_resources'
require_relative 'actions/cloud_formation/stack_named_resource'
require_relative 'actions/cloud_formation/stack_create_change_set'
require_relative 'actions/cloud_formation/stack_describe_change_set'
require_relative 'actions/cloud_formation/stack_delete_change_set'

module AwsHelpers
  class CloudFormation < AwsHelpers::Client
    # CloudFormation utilities for creating, deleting and modifying templates
    #
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    #
    # @example Initialise CloudFormation Client
    #    client = AwsHelpers::CloudFormation.new
    #
    # @return [Aws::CloudFormation::Client]
    #
    def initialize(options = {})
      super(options)
    end

    # Create a stack from scratch using a pre-defined template.
    # Template reference: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html
    #
    # @param stack_name [String] Name given to the Stack
    # @param template [JSON] The cloud formation json template
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [Array] :parameters Parameters to include in template e.g. [{ parameter_key: 'key', parameter_value: 'value' }]
    # @option options [Array] :capabilities Capabilities required when provisioning the stack e.g ['CAPABILITY_IAM']
    # @option options [String] :bucket_name Upload to an S3 bucket before provisioning
    # @option options [Boolean] :bucket_encrypt server side encryption on the upload bucket, 'AES256'
    # @option options [IO] :stdout Override $stdout when logging output
    # @option options [Hash{Symbol => Integer}] :polling stack polling attempts and delay
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 40,
    #     :delay => 15 # seconds
    #   }
    #   ```
    #
    # @example Create a basic cloudformation stack with a single instance
    #   AwsHelpers::CloudFormation.new.stack_provision(
    #     "TestStackName",'{
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
    #
    # @example Remove the names stack from AWS
    #   AwsHelpers::CloudFormation.new.stack_delete("TestStackName")
    #
    # @return [nil]
    #
    def stack_delete(stack_name, options = {})
      AwsHelpers::Actions::CloudFormation::StackDelete.new(config, stack_name, options).execute
    end

    # Modify the parameters of an existing stack.
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
    #
    # @example
    #   AwsHelpers::CloudFormation.new.stack_modify_parameters(
    #     "TestStackName",
    #     [ { parameter_key: 'InstanceImageId', parameter_value: 'ami-123ab123' }]
    #   )
    #
    # @return
    #
    def stack_modify_parameters(stack_name, parameters, options = {})
      AwsHelpers::Actions::CloudFormation::StackModifyParameters.new(config, stack_name, parameters, options).execute
    end

    # Return the parameters of a cloudformation stack
    #
    # @param stack_name [String] Name given to the Stack
    #
    # @example Return the stack parameters
    #  AwsHelpers::CloudFormation.new.stack_parameters("TestStackName")
    #
    # @return [Array<struct Aws::CloudFormation::Types::Parameter>] The list of parameters defined for the Stack
    #
    def stack_parameters(stack_name)
      AwsHelpers::Actions::CloudFormation::StackInformation.new(config, stack_name, 'parameters').execute
    end

    # Return the outputs of a cloudformation stack
    #
    # @param stack_name [String] Name given to the Stack
    #
    # @example Return the stack outputs
    #  AwsHelpers::CloudFormation.new.stack_outputs("TestStackName")
    #
    # @return [Array<struct Aws::CloudFormation::Types::Output>] The list of outputs defined for the Stack
    #
    def stack_outputs(stack_name)
      AwsHelpers::Actions::CloudFormation::StackInformation.new(config, stack_name, 'outputs').execute
    end

    # Return true or false if the stack exists or not
    #
    # @param stack_name [String] Name of the stack to check
    #
    # @example Checks if the stack exists
    #  AwsHelpers::CloudFormation.new.stack_exists?("TestStackName")
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
    # @example Return a list of resources (for a stack to be created, there must at least be 1)
    #  AwsHelpers::CloudFormation.new.stack_resources("TestStackName")
    #
    # @return [Array<struct Aws::CloudFormation::Types::StackResource>] The list of resources defined for the Stack
    #
    def stack_resources(stack_name)
      AwsHelpers::Actions::CloudFormation::StackResources.new(config, stack_name).execute
    end

    # Return a matching resource associated with the stack
    #
    # @param stack_name [String] Name given to the Stack
    # @param resource_id [String] The Logical Resource Identifier
    #
    # @example Return a name resource
    #  AwsHelpers::CloudFormation.new.stack_named_resource("TestStackName", "TestInstance")
    #
    # @return [struct Aws::CloudFormation::Types::StackResourceDetail] The named resource
    #
    def stack_named_resource(stack_name, resource_id)
      AwsHelpers::Actions::CloudFormation::StackNamedResource.new(config, stack_name, resource_id).execute
    end

    # Create a new stack change set
    #
    # @param stack_name [String] Name given to the Stack
    # @param change_set_name [String] Name given to the Change Set
    # @param template_json [JSON] New Stack Template to compare
    #
    # @example Return a name resource
    #   AwsHelpers::CloudFormation.new.stack_create_change_set("TestStackName","TestChangeSet",'
    #     {
    #       "Resources": {
    #          "TestInstance": {
    #              "Type" : "AWS::EC2::Instance",
    #              "Properties": {
    #              "ImageId": "ami-f5210196"
    #              }
    #            }
    #          },
    #          "Parameters" : {
    #              "ImageId": {
    #              "Type" : "AWS::EC2::Image::Id",
    #              "Default" : "ami-f5210196"
    #            }
    #          },
    #          "Outputs": {
    #           "InstanceId" : {
    #           "Description" : "InstanceId of the newly created EC2 instance",
    #           "Value" : { "Ref" : "TestInstance" }
    #          }
    #       }
    #     }'
    #   )
    #
    # @return [struct Aws::CloudFormation::Types::CreateChangeSetOutput] The named resource
    #
    def stack_create_change_set(stack_name, change_set_name, template_json)
      AwsHelpers::Actions::CloudFormation::StackCreateChangeSet.new(config, stack_name, change_set_name, template_json).execute
    end

    # Describe a change set
    #
    # @param stack_name [String] Name given to the Stack
    # @param change_set_name [String] Name given to the Change Set
    # @option options [IO] :stdout Override $stdout when logging output
    #
    # @example Return the change set details
    #  AwsHelpers::CloudFormation.new.stack_describe_change_set("TestStackName", "TestChangeSet")
    #
    # @return [struct Aws::CloudFormation::Types::DescribeChangeSetOutput] The change set details
    #
    def stack_describe_change_set(stack_name, change_set_name, options)
      AwsHelpers::Actions::CloudFormation::StackDescribeChangeSet.new(config, stack_name, change_set_name, options).execute
    end

    # Delete a change set
    #
    # @param stack_name [String] Name given to the Stack
    # @param change_set_name [String] Name given to the Change Set
    # @option options [IO] :stdout Override $stdout when logging output
    #
    # @example Remove a change set
    #  AwsHelpers::CloudFormation.new.stack_delete_change_set("TestStackName", "TestChangeSet")
    #
    # @return [struct Seahorse::Client::Response] An empty response
    #
    def stack_delete_change_set(stack_name, change_set_name, options)
      AwsHelpers::Actions::CloudFormation::StackDeleteChangeSet.new(config, stack_name, change_set_name, options).execute
    end
  end
end

