module AwsHelpers
  module Utilities
    class PollingFailed < StandardError; end
    class FailedStateError < PollingFailed; end
    class TooManyAttemptsError < PollingFailed
      def initialize(attempts)
        @attempts = attempts
        super(format('stopped waiting after %d attempts without success', attempts))
      end

      # @return [Integer]
      attr_reader :attempts
    end
  end
end
