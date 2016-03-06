module AwsHelpers
  module Actions
    module EC2

      class SnapshotsDescribe

        def initialize(config, snapshot_ids, options={})
          @client = config.aws_ec2_client
          @snapshot_ids = snapshot_ids
          @stdout = options[:stdout] || $stdout
        end

        def execute
          response = @client.describe_snapshots(snapshot_ids: @snapshot_ids)
          response.snapshots.each { |snapshot|
            @stdout.puts "Snapshot:#{snapshot.snapshot_id} State:#{snapshot.state} Progress:#{snapshot.progress}"
          }
        end

      end

    end
  end
end
