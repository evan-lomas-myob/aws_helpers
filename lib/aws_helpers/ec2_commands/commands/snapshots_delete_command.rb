require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class SnapshotsDeleteCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          @request.snapshot_ids.each do |snapshot_id|
            @request.stdout.puts "Deleting Snapshot:#{snapshot_id}"
            @client.delete_snapshot(snapshot_id: snapshot_id)
          end
        end
      end
    end
  end
end
