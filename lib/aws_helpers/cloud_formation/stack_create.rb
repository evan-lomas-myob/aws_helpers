require_relative 'stack_exists'
require_relative 'stack_progress'

module AwsHelpers
  module CloudFormation
    class StackCreate

      def initialize(cloud_formation_client, create_request)
        @cloud_formation_client = cloud_formation_client
        @create_request = create_request
        @stack_name = create_request[:stack_name]
        @stack_exists = StackExists.new(cloud_formation_client, @stack_name)
      end

      def execute
        puts "Creating #{@stack_name}"
        @cloud_formation_client.create_stack(@create_request)

        until @stack_exists.execute
          sleep 5
        end
        StackProgress.new(@cloud_formation_client, @stack_name).execute
      end

    end
  end
end