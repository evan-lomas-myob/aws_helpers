require 'aws_helpers/ec2_commands/commands/snapshots_delete_command'
require 'aws_helpers/ec2_commands/requests/snapshots_delete_request'

describe AwsHelpers::EC2Commands::Commands::SnapshotsDeleteCommand do
  let(:instance_id) { '123' }
  let(:image_name) { 'Batman' }
  let(:image_id) { '321' }
  let(:snapshot_ids) { [1,2,3] }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::SnapshotsDeleteRequest.new }

  before do
    request.snapshot_ids = snapshot_ids
    @command = AwsHelpers::EC2Commands::Commands::SnapshotsDeleteCommand.new(config, request)
  end

  it 'calls delete snapshot for each of the snapshot ids' do
    snapshot_ids.each do |id|
      expect(ec2_client)
        .to receive(:delete_snapshot)
        .with(snapshot_id: id)
    end
    @command.execute
  end
end
