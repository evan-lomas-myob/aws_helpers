module AwsHelpers
  module Utilities

    class GenericWaiter

      attr_accessor :stop

      def initialize
        @stop = false
      end

      def wait_unit(delay, max_attempts, &block)
        attempts = 0
        while true
          block.call(self)
          break if stop
          attempts = attempts + 1
          raise Aws::Waiters::Errors::TooManyAttemptsError.new(attempts) if attempts == max_attempts
          sleep(delay)
        end

      end

    end

  end
end
