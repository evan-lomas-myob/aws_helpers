require 'rspec'
require 'aws_helpers/rds'
require 'aws_helpers/rds_actions/snapshot_latest'

describe AwsHelpers::RDSActions::SnapshotLatest do

  let(:db_instance_id) { 'my_instance_id' }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(aws_rds_client: double, aws_iam_client: double) }
  let(:snapshot_latest) { double(AwsHelpers::RDSActions::SnapshotLatest) }

  it '#snapshot_delete' do
    allow(AwsHelpers::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::RDSActions::SnapshotLatest).to receive(:new).with(config, db_instance_id).and_return(snapshot_latest)
    expect(snapshot_latest).to receive(:execute)
    AwsHelpers::RDS.new(options).snapshot_latest(db_instance_id: db_instance_id)
  end
  
end