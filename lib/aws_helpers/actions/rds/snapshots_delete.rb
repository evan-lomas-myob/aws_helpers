require 'aws_helpers/utilities/subtract_time'

module AwsHelpers
  module Actions
    module RDS

      class SnapshotsDelete

        def initialize(config, db_instance_id, options = {})
          @config = config
          @db_instance_id = db_instance_id
          @stdout = options[:stdout] ||= $stdout
          @now = options[:now]
          @hours = options[:hours]
          @days = options[:days]
          @months = options[:months]
          @years = options[:years]
        end

        def execute
          client = @config.aws_rds_client
          response = client.describe_db_snapshots(db_instance_identifier: @db_instance_id, snapshot_type: 'manual')
          delete_older_than = AwsHelpers::Utilities::SubtractTime.new(now: @now, hours: @hours, days: @days, months: @months, years: @years).execute
          snapshots = response.db_snapshots
          snapshots.sort_by! { |snapshot| snapshot.snapshot_create_time }
          snapshots.each do |snapshot|
            create_time = snapshot.snapshot_create_time
            identifier = snapshot.db_snapshot_identifier
            if create_time <= delete_older_than
              client.delete_db_snapshot(db_snapshot_identifier: identifier)
              @stdout.puts "Deleting Snapshot=#{identifier}, Created=#{create_time}"
            end
          end

        end

      end

    end
  end
end