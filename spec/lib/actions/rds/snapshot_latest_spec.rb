require 'aws_helpers/rds'
require 'aws_helpers/actions/rds/snapshot_latest'

include AwsHelpers
include AwsHelpers::Actions::RDS

describe SnapshotLatest do

  let(:db_instance_id) { 'my_instance_id' }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(aws_rds_client: double, aws_iam_client: double) }
  let(:snapshot_latest) { double(SnapshotLatest) }

  it '#snapshot_delete' do
    allow(Config).to receive(:new).with(options).and_return(config)
    allow(SnapshotLatest).to receive(:new).with(config, db_instance_id).and_return(snapshot_latest)
    expect(snapshot_latest).to receive(:execute)
    RDS.new(options).snapshot_latest(db_instance_id: db_instance_id)
  end
  
end