require 'aws_helpers/actions/rds/instance_state'
require 'aws_helpers/utilities/polling'
require 'aws_helpers/rds/commands/command'

module AwsHelpers
  module RDS
    module Commands
      class PollInstanceAvailableCommand < AwsHelpers::RDS::Commands::Command
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
            response = @rds_client.describe_db_instances(db_instance_identifier: @db_instance_identifier)
            instance = response.db_instances.find { |i| i.db_instance_identifier = @db_instance_identifier }
            status = instance.db_instance_status
            stdout.puts "RDS Instance=#{@db_instance_identifier}, Status=#{status}"
            status == InstanceState::AVAILABLE
          end
        end

      end
    end
  end
end
