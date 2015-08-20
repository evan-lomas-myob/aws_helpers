module AwsHelpers
  module Utilities

    module Polling

      def poll(delay, max_attempts, &block)
        attempts = 0
        while true
          break if block.call
          attempts += 1
          raise Aws::Waiters::Errors::TooManyAttemptsError.new(attempts) if attempts == max_attempts
          sleep(delay)
        end

      end

    end
  end
end
