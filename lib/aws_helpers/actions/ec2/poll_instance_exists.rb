require 'aws_helpers/utilities/polling'

module AwsHelpers
  module Actions
    module EC2

      class PollInstanceExists

        include AwsHelpers::Utilities::Polling

        def initialize(instance_id, options = {})
          @instance_id = instance_id
          @stdout = options[:stdout] || $stdout
          @delay = options[:delay] || 15
          @max_attempts = options[:max_attempts] || 8
        end

        def execute
          poll(@delay, @max_attempts) {
            Aws::EC2::Instance.new(@instance_id).exists?
          }
        end

      end
    end
  end
end

