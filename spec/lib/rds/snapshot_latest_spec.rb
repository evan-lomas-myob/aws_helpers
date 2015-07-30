require 'rspec'
require 'aws_helpers/rds/client'
require 'aws_helpers/rds/snapshot_latest'

describe 'AwsHelpers::RDS::SnapshotLatest' do

  let(:db_instance_id) { 'my_instance_id' }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_rds_client: double, aws_iam_client: double) }
  let(:snapshot_latest) { double(AwsHelpers::RDS::SnapshotLatest) }

  it '#snapshot_delete' do

    allow(AwsHelpers::RDS::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::RDS::SnapshotLatest).to receive(:new).with(config, db_instance_id).and_return(snapshot_latest)
    expect(snapshot_latest).to receive(:execute)
    AwsHelpers::RDS::Client.new(options).snapshot_latest(db_instance_id)

  end
  
end