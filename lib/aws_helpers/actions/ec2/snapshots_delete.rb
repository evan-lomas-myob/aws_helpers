module AwsHelpers
  module Actions
    module EC2
      class SnapshotsDelete
        def initialize(config, snapshot_ids, options = {})
          @client = config.aws_ec2_client
          @snapshot_ids = snapshot_ids
          @stdout = options[:stdout] || $stdout
        end

        def execute
          @snapshot_ids.each do |snapshot_id|
            @stdout.puts "Deleting Snapshot:#{snapshot_id}"
            @client.delete_snapshot(snapshot_id: snapshot_id)
          end
        end
      end
    end
  end
end
