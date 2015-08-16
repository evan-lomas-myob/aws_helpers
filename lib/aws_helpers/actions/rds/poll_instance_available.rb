require 'aws_helpers/actions/rds/instance_state'
require 'aws_helpers/utilities/polling'

module AwsHelpers
  module Actions
    module RDS

      class PollInstanceAvailable

        def initialize(config, db_instance_identifier, options={})
          @config = config
          @db_instance_identifier = db_instance_identifier
          @stdout = options[:stdout] ||= $stdout
          @max_attempts = options[:max_attempts] ||= 60
          @delay = options[:delay] || 30
        end

        def execute
          rds_client = @config.aws_rds_client
          pooling = AwsHelpers::Utilities::Polling.new
          pooling.start(@delay, @max_attempts) {
            response = rds_client.describe_db_instances(db_instance_identifier: @db_instance_identifier)
            instance = response.db_instances.find { |instance| instance.db_instance_identifier = @db_instance_identifier }
            status = instance.db_instance_status
            @stdout.puts "RDS Instance=#{@db_instance_identifier}, Status=#{status}"
            pooling.stop if status == InstanceState::AVAILABLE
          }
        end

      end

    end
  end
end
