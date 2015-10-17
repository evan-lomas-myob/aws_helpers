require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/ec2/delete_snapshots'

describe AwsHelpers::Actions::EC2::DeleteSnapshots do

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
      AwsHelpers::Actions::EC2::DeleteSnapshots.new(config, [snapshot_id], stdout: stdout).execute
    end

    it 'should call stdout #puts with a description of the snapshot being deleted' do
      expect(stdout).to receive(:puts).with("Deleting Snapshot:#{snapshot_id}")
      AwsHelpers::Actions::EC2::DeleteSnapshots.new(config, [snapshot_id], stdout: stdout).execute
    end

  end

end