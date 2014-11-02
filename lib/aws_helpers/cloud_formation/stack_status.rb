
module AwsHelpers
  module CloudFormation

    UPDATE_ROLLBACK_COMPLETE = 'UPDATE_ROLLBACK_COMPLETE'
    CREATE_COMPLETE = 'CREATE_COMPLETE'
    ROLLBACK_COMPLETE = 'ROLLBACK_COMPLETE'
    UPDATE_COMPLETE = 'UPDATE_COMPLETE'
    CREATE_IN_PROGRESS = 'CREATE_IN_PROGRESS'
    CREATE_FAILED = 'CREATE_FAILED'
    DELETE_FAILED = 'DELETE_FAILED'
    ROLLBACK_FAILED = 'ROLLBACK_FAILED'
    UPDATE_ROLLBACK_FAILED = 'UPDATE_ROLLBACK_FAILED'

    class StackStatus

      def initialize(stack)
        @stack = stack
      end

      def poll

        loop do
          aws_stack = @stack.describe_stack
          status = aws_stack[:stack_status]
          name = aws_stack[:stack_name]

          puts "Stack - #{name} status #{status}"

          case status
            when CREATE_COMPLETE, UPDATE_COMPLETE, UPDATE_ROLLBACK_COMPLETE, ROLLBACK_FAILED, ROLLBACK_COMPLETE
              break
            else
              sleep 30
          end
        end

      end

      def check_failure
        aws_stack = @stack.describe_stack
        status = aws_stack[:stack_status]
        name = aws_stack[:stack_name]

        if [UPDATE_ROLLBACK_COMPLETE, ROLLBACK_FAILED, ROLLBACK_COMPLETE].include?(status)
          raise "Failed to provision #{name}"
        end

      end
    end
  end
end