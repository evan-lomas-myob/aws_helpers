module AwsHelpers
  module Utilities
    module Polling
      def poll(delay, max_attempts)
        attempts = 0
        Kernel.loop do
          break if yield(attempts)
          attempts += 1
          raise Aws::Waiters::Errors::TooManyAttemptsError.new(attempts) if attempts == max_attempts # rubocop:disable Style/RaiseArgs
          sleep(delay)
        end
      end
    end
  end
end
