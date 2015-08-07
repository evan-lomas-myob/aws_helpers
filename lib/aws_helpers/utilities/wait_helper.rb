module AwsHelpers
  module Utilities

    class WaitHelper

      def self.wait(client, timeout, waiter_names, params, &block)
        client.wait_until(waiter_names, params) { |waiter|
          waiter.max_attempts = timeout / waiter.delay
          waiter.before_wait do |attempts, response|
            block.call(attempts, response)
          end
        }
      end

    end

  end
end