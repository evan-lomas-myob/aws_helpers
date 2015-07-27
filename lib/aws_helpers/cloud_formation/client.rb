require 'aws-sdk-core'
require_relative '../common/client'
require_relative 'config'

module AwsHelpers

  module CloudFormation

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(AwsHelpers::CloudFormation::Config(options))
      end

      def stack_provision(stack_name, template, options = {})
#        CloudFormation::StackProvision.new(config.aws_cloud_formation_client, config.aws_s3_client, stack_name, template, options).execute
      end

      def stack_modify_parameters(stack_name, parameters)
#        CloudFormation::StackModifyParameters.new(config.aws_cloud_formation_client, stack_name, parameters).execute
      end

      def stack_delete(stack_name)
#        CloudFormation::StackDelete.new(config.aws_cloud_formation_client, stack_name).execute
      end

      def stack_outputs(stack_name)
#        CloudFormation::StackOutputs.new(config.aws_cloud_formation_client, stack_name).execute
      end

      def stack_parameters(stack_name)
#        CloudFormation::StackParameters.new(config.aws_cloud_formation_client, stack_name).execute
      end

      def stack_exists?(stack_name)
#        CloudFormation::StackExists.new(config.aws_cloud_formation_client, stack_name).execute
      end

    end

  end

end

