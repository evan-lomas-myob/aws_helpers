require 'aws_helpers/actions/rds/instance_state'
require 'aws_helpers/utilities/polling'
require 'aws_helpers/command'

module AwsHelpers
  module RDSCommands
    module Commands
      class PollInstanceAvailableCommand < AwsHelpers::Command
        include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @rds_client = config.aws_rds_client
          @db_instance_identifier = request.db_instance_identifier
          @std_out = request.std_out
          @max_attempts = request.instance_polling[:max_attempts] || 60
          @delay = request.instance_polling[:delay] || 30
        end

        def execute
          poll(@delay, @max_attempts) do
            instance = @rds_client.describe_db_instances(db_instance_identifier: @db_instance_identifier).db_instances.first
            status = instance.db_instance_status
            std_out.puts "RDS Instance=#{@db_instance_identifier}, Status=#{status}"
            status == 'available'
          end
        end
      end
    end
  end
end
