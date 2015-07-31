require 'rspec'
require 'aws_helpers/rds/client'
require 'aws_helpers/rds/snapshots_delete'

describe 'AwsHelpers::RDS::SnapshotsDelete' do

  let(:db_instance_id) { 'my_instance_id' }
  let(:default_days) { nil }
  let(:default_months) { nil }
  let(:default_years) { nil }

  let(:days) { 1 }
  let(:months) { 1 }
  let(:years) { 1 }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_rds_client: double, aws_iam_client: double) }
  let(:snapshots_delete) { double(AwsHelpers::RDS::SnapshotsDelete) }

  it '#snapshot_delete with db_instance supplied' do

    allow(AwsHelpers::RDS::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::RDS::SnapshotsDelete).to receive(:new).with(config, db_instance_id, default_days, default_months, default_years).and_return(snapshots_delete)
    expect(snapshots_delete).to receive(:execute)
    AwsHelpers::RDS::Client.new(options).snapshots_delete(db_instance_id: db_instance_id)

  end

  it '#snapshot_delete with days, months and years supplied' do

    # need to add cases where days, months, years not supplied

    allow(AwsHelpers::RDS::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::RDS::SnapshotsDelete).to receive(:new).with(config, db_instance_id, days, months, years).and_return(snapshots_delete)
    expect(snapshots_delete).to receive(:execute)
    AwsHelpers::RDS::Client.new(options).snapshots_delete(db_instance_id: db_instance_id, days:days, months: months, years: years)

  end
  
end