require 'aws-sdk-core'
require_relative 'stack_progress'

module AwsHelpers
  module CloudFormation
    class StackUpdate

      def initialize(update_request, client = Aws::CloudFormation::Client.new)
        @update_request = update_request
        @stack_name = update_request[:stack_name]
        @client = client
      end

      def execute

        puts "Updating #{@stack_name}"
        begin
          @client.update_stack(@update_request)
          StackProgress.new(@stack_name, @client).execute
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