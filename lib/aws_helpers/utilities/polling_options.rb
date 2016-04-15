module AwsHelpers
  module Utilities
    module PollingOptions
      private

      def create_options(stdout, polling_options)
        {}.tap do |options|
          options[:stdout] = stdout if stdout
          if polling_options
            max_attempts = polling_options[:max_attempts]
            delay = polling_options[:delay]
            options[:max_attempts] = max_attempts if max_attempts
            options[:delay] = delay if delay
          end
        end
      end
    end
  end
end
