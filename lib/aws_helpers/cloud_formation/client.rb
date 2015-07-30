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

      def initialize(options = {})
        super(AwsHelpers::CloudFormation::Config.new(options))
      end

      def stack_create(stack_name, template, options = {})
      #def stack_create(options = {})
        AwsHelpers::CloudFormation::StackCreate.new(config, stack_name, template, options).execute
      end

      # stack_create 'stack_name', 'template' # current use
      # stack_create stack_name: 'stack_name', template: 'template' # named arguments
      #stack_create params(Stack.new('stack'), ..) # - helpers classes

      def stack_delete(stack_name)
        AwsHelpers::CloudFormation::StackDelete.new(config, stack_name).execute
      end

      def stack_modify_parameters(stack_name, parameters)
        AwsHelpers::CloudFormation::StackModifyParameters.new(config, stack_name, parameters).execute
      end

      def stack_information(stack_name, info_field)
        AwsHelpers::CloudFormation::StackInformation.new(config, stack_name, info_field).execute
      end

      def stack_exists?(stack_name)
        AwsHelpers::CloudFormation::StackExists.new(config, stack_name).execute
      end

    end

  end

end

