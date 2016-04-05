module AwsHelpers
  module Utilities
    module PollingOptions
      def create_options(stdout, polling_options)
        {}.tap { |options|
          options[:stdout] = stdout if stdout
          if polling_options
            max_attempts = polling_options[:max_attempts]
            delay = polling_options[:delay]
            options[:max_attempts] = max_attempts if max_attempts
            options[:delay] = delay if delay
          end
        }
      end
    end
  end
end
