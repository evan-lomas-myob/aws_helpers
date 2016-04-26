require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class PollInstanceHealthyCommand < AwsHelpers::Command
        include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @ec2_client = config.aws_ec2_client
          @request = request
        end

        def execute
          poll(@request.instance_polling[:delay], @request.instance_polling[:max_attempts]) do
            begin
              @rc2_client.describe_instances(instance_ids: [@instance_id])
              true
            rescue Aws::EC2::Errors::InvalidInstanceIDNotFound
              false
            end
          end
        end
      end
    end
  end
end
