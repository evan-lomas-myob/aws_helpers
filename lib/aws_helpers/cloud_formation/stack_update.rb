require 'aws-sdk-core'
require_relative 'stack_progress'

module AwsHelpers
  module CloudFormation
    class StackUpdate

      def initialize(cloud_formation_client, update_request)
        @cloud_formation_client = cloud_formation_client
        @update_request = update_request
        @stack_name = update_request[:stack_name]
      end

      def execute

        puts "Updating #{@stack_name}"
        begin
          @cloud_formation_client.update_stack(@update_request)
          StackProgress.new(@cloud_formation_client, @stack_name).execute
        rescue Aws::CloudFormation::Errors::ValidationError => validation_error
          if validation_error.message == 'No updates are to be performed.'
            puts "No updates to perform for #{@stack_name}."
          else
            raise validation_error
          end
        end

      end

    end
  end
end