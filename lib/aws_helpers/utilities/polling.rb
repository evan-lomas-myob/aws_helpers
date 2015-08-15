module AwsHelpers
  module Utilities

    class Polling

      def stop
        @stop = true
      end

      def start(delay, max_attempts, &block)
        @stop = false
        attempts = 0
        while true
          block.call
          break if @stop
          attempts += 1
          raise Aws::Waiters::Errors::TooManyAttemptsError.new(attempts) if attempts == max_attempts
          sleep(delay)
        end

      end

    end

  end
end
