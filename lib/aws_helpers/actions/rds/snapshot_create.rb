require 'aws_helpers/actions/rds/poll_instance_available'
require 'aws_helpers/actions/rds/snapshot_construct_name'
require 'aws_helpers/actions/rds/poll_snapshot_available'

module AwsHelpers
  module Actions
    module RDS
      class SnapshotCreate
        def initialize(config, db_instance_identifier, options = {})
          @config = config
          @db_instance_identifier = db_instance_identifier
          stdout = options[:stdout]
          @construct_name_options = create_construct_name_options(options[:use_name])
          @poll_instance_options = create_polling_options(stdout, options[:instance_polling])
          @poll_snapshot_options = create_polling_options(stdout, options[:snapshot_polling])
        end

        def execute
          PollInstanceAvailable.new(@config, @db_instance_identifier, @poll_instance_options).execute
          snapshot_name = AwsHelpers::Actions::RDS::SnapshotConstructName.new(@config, @db_instance_identifier, @construct_name_options).execute
          @config
            .aws_rds_client
            .create_db_snapshot(
              db_instance_identifier: @db_instance_identifier,
              db_snapshot_identifier: snapshot_name
            )
          AwsHelpers::Actions::RDS::PollSnapshotAvailable.new(@config, snapshot_name, @poll_snapshot_options).execute
        end

        private

        def create_construct_name_options(use_name)
          options = {}
          options[:use_name] = use_name if use_name
          options
        end

        def create_polling_options(stdout, polling)
          options = {}
          options[:stdout] = stdout if stdout
          if polling
            max_attempts = polling[:max_attempts]
            delay = polling[:delay]
            options[:max_attempts] = max_attempts if max_attempts
            options[:delay] = delay if delay
          end
          options
        end
      end
    end
  end
end
