require 'rspec'
require 'aws_helpers/rds/client'
require 'aws_helpers/rds/snapshots_delete'

describe 'AwsHelpers::RDS::SnapshotsDelete' do

  let(:db_instance_id) { 'my_instance_id' }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_rds_client: double, aws_iam_client: double) }
  let(:snapshots_delete) { double(AwsHelpers::RDS::SnapshotsDelete) }

  it '#snapshot_delete' do

    allow(AwsHelpers::RDS::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::RDS::SnapshotsDelete).to receive(:new).with(config, db_instance_id, options).and_return(snapshots_delete)
    expect(snapshots_delete).to receive(:execute)
    AwsHelpers::RDS::Client.new(options).snapshots_delete(db_instance_id, options)

  end
  
end