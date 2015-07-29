require 'aws-sdk-core'
require_relative '../common/client'
require_relative 'config'
require_relative 'stack_provision'
require_relative 'stack_modify_parameters'
require_relative 'stack_delete'
require_relative 'stack_information'
require_relative 'stack_exists'

module AwsHelpers

  module CloudFormation

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(AwsHelpers::CloudFormation::Config.new(options))
      end

      def stack_provision(stack_name, template, options = {})
        AwsHelpers::CloudFormation::StackProvision.new(config.aws_cloud_formation_client, config.aws_s3_client, stack_name, template, options).execute
      end

      def stack_modify_parameters(stack_name, parameters)
        AwsHelpers::CloudFormation::StackModifyParameters.new(config.aws_cloud_formation_client, stack_name, parameters).execute
      end

      def stack_delete(stack_name)
        AwsHelpers::CloudFormation::StackDelete.new(config.aws_cloud_formation_client, stack_name).execute
      end

      def stack_information(stack_name, info_field)
        AwsHelpers::CloudFormation::StackInformation.new(config.aws_cloud_formation_client, stack_name, info_field).execute
      end

      def stack_exists?(stack_name)
        AwsHelpers::CloudFormation::StackExists.new(config.aws_cloud_formation_client, stack_name).execute
      end

    end

  end

end

