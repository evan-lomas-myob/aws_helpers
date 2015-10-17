require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/ec2/snapshots_delete'

describe AwsHelpers::Actions::EC2::SnapshotsDelete do

  describe '#execute' do

    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
    let(:stdout) { instance_double(IO) }
    let(:snapshot_id) { 'snapshot_id' }

    before(:each) do
      allow(aws_ec2_client).to receive(:delete_snapshot)
      allow(stdout).to receive(:puts)
    end

    it 'should call Aws::EC2::Client #delete_snapshot with the correct parameters' do
      expect(aws_ec2_client).to receive(:delete_snapshot).with(snapshot_id: snapshot_id)
      AwsHelpers::Actions::EC2::SnapshotsDelete.new(config, [snapshot_id], stdout: stdout).execute
    end

    it 'should call stdout #puts with a description of the snapshot being deleted' do
      expect(stdout).to receive(:puts).with("Deleting Snapshot:#{snapshot_id}")
      AwsHelpers::Actions::EC2::SnapshotsDelete.new(config, [snapshot_id], stdout: stdout).execute
    end

  end

end