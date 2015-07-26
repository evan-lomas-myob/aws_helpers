require 'aws-sdk-core'
require_relative '../common/client'

module AwsHelpers

  module CloudFormation

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(options)
      end

      def stack_provision(stack_name, template, options = {})
#        CloudFormation::StackProvision.new(aws_cloud_formation_client, aws_s3_client, stack_name, template, options).execute
      end

      def stack_modify_parameters(stack_name, parameters)
#        CloudFormation::StackModifyParameters.new(aws_cloud_formation_client, stack_name, parameters).execute
      end

      def stack_delete(stack_name)
#        CloudFormation::StackDelete.new(aws_cloud_formation_client, stack_name).execute
      end

      def stack_outputs(stack_name)
#        CloudFormation::StackOutputs.new(aws_cloud_formation_client, stack_name).execute
      end

      def stack_parameters(stack_name)
#        CloudFormation::StackParameters.new(aws_cloud_formation_client, stack_name).execute
      end

      def stack_exists?(stack_name)
#        CloudFormation::StackExists.new(aws_cloud_formation_client, stack_name).execute
      end

      private

      def aws_cloud_formation_client
        @aws_cloud_formation_client = Aws::CloudFormation::Client.new(@options)
      end

      def aws_s3_client
        @aws_s3_client = Aws::S3::Client.new(@options)
      end

    end

  end

end

