require 'aws_helpers/utilities/polling'

module AwsHelpers
  module Actions
    module Redshift
      class PollInstanceExists
        include AwsHelpers::Utilities::Polling

        def initialize(config, instance_id, options = {})
          @client = config.aws_redshift_client
          @instance_id = instance_id
          @stdout = options[:stdout] ||= $stdout
          @delay = options[:delay] ||= 15
          @max_attempts = options[:max_attempts] ||= 8
        end

        def execute
          poll(@delay, @max_attempts) do
            begin
              @client.describe_instances(instance_ids: [@instance_id])
              true
            rescue Aws::Redshift::Errors::InvalidInstanceIDNotFound
              false
            end
          end
        end
      end
    end
  end
end
