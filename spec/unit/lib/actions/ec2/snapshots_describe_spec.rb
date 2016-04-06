require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/ec2/snapshots_describe'

describe AwsHelpers::Actions::EC2::SnapshotsDescribe do
  describe '#execute' do
    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
    let(:stdout) { instance_double(IO) }
    let(:snapshot_ids) { ['snapshot_id'] }
    let(:response) do
      Aws::EC2::Types::DescribeSnapshotsResult.new(
        snapshots: [
          Aws::EC2::Types::Snapshot.new(snapshot_id: 'snapshot_id', state: 'state', progress: '50')
        ]
      )
    end

    before(:each) do
      allow(aws_ec2_client).to receive(:describe_snapshots).and_return(response)
      allow(stdout).to receive(:puts)
    end

    it 'should call Aws::EC2::Client #describe_snapshots with correct parameters' do
      expect(aws_ec2_client).to receive(:describe_snapshots).with(snapshot_ids: snapshot_ids)
      AwsHelpers::Actions::EC2::SnapshotsDescribe.new(config, snapshot_ids).execute
    end

    it 'should call stdout #puts with the snapshot details' do
      expect(stdout).to receive(:puts).with('Snapshot:snapshot_id State:state Progress:50')
      AwsHelpers::Actions::EC2::SnapshotsDescribe.new(config, snapshot_ids, stdout: stdout).execute
    end
  end
end
