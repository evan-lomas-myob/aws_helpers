module AwsHelpers
  module Utilities

    class PollingFailed < StandardError; end
    class FailedStateError < PollingFailed; end
    class TooManyAttemptsError < PollingFailed

      MSG = 'stopped waiting after %d attempts without success'

      def initialize(attempts)
        @attempts = attempts
        super(MSG % [attempts])
      end

      # @return [Integer]
      attr_reader :attempts

    end

  end
end
