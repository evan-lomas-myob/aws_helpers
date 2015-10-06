require_relative 'describe_stack'
require_relative 'stack_status'

module AwsHelpers
  module CloudFormation
    class PollStackStatus

      def initialize(cloud_formation_client, stack_name)
        @describe_stack = DescribeStack.new(cloud_formation_client, stack_name)
      end

      def execute

        loop do
          aws_stack = @describe_stack.execute
          status = aws_stack[:stack_status]
          name = aws_stack[:stack_name]
          puts "Stack - #{name} status #{status}"

          case status
            when CREATE_COMPLETE, DELETE_COMPLETE, ROLLBACK_COMPLETE, UPDATE_COMPLETE, UPDATE_ROLLBACK_COMPLETE, ROLLBACK_FAILED, UPDATE_ROLLBACK_FAILED, DELETE_FAILED
              break
            else
              sleep 30
          end
        end

      end

    end
  end
end


