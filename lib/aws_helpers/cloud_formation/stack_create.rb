require 'aws-sdk-core'
require_relative 'stack_exists'
require_relative 'stack_progress'

module AwsHelpers
  module CloudFormation
    class StackCreate

      def initialize(create_request, client = Aws::CloudFormation::Client.new)
        @create_request = create_request
        @stack_name = create_request[:stack_name]
        @client = client
        @stack_exists = StackExists.new(@stack_name, client)
      end

      def execute
        puts "Creating #{@stack_name}"
        @client.create_stack(@create_request)

        until @stack_exists.execute
          sleep 5
        end
        StackProgress.new(@stack_name, @client).execute
      end

    end
  end
end