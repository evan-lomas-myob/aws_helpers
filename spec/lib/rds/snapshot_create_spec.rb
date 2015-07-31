require 'rspec'
require 'aws_helpers/rds/client'
require 'aws_helpers/rds/snapshot_create'

describe 'AwsHelpers::RDS::SnapshotCreate' do

  let(:db_instance_id) { 'my_instance_id' }
  let(:default_use_name) { false }
  let(:use_name) { true }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_rds_client: double, aws_iam_client: double) }
  let(:snapshot_create) { double(AwsHelpers::RDS::SnapshotCreate) }

  it '#snapshot_create' do

    allow(AwsHelpers::RDS::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::RDS::SnapshotCreate).to receive(:new).with(config, db_instance_id, default_use_name).and_return(snapshot_create)
    expect(snapshot_create).to receive(:execute)
    AwsHelpers::RDS::Client.new(options).snapshot_create(db_instance_id: db_instance_id)

  end

  it '#snapshot_create with use_name = true' do

    allow(AwsHelpers::RDS::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::RDS::SnapshotCreate).to receive(:new).with(config, db_instance_id, use_name).and_return(snapshot_create)
    expect(snapshot_create).to receive(:execute)
    AwsHelpers::RDS::Client.new(options).snapshot_create(db_instance_id: db_instance_id, use_name: use_name)

  end

end