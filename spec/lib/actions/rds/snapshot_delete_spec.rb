require 'aws_helpers/rds'
require 'aws_helpers/utilities/subtract_time'
require 'aws_helpers/actions/rds/snapshots_delete'

include AwsHelpers
include AwsHelpers::Actions::RDS

describe SnapshotsDelete do

  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }

  let(:db_instance_identifier) { 'db_instance_id' }
  let(:db_snapshot_identifier) { 'db_snapshot_identifier_1' }

  let(:db_snapshots) { [
      double(:db_snapshots, db_snapshot_identifier: 'db_snapshot_identifier_1', snapshot_create_time: Time.new(2015, 01, 01, 0, 0, 0)),
  ] }

  let(:hours) { 1 }
  let(:days) { 1 }
  let(:months) { 1 }
  let(:years) { 1 }

  before(:each) do
    allow(rds_client).to receive(:describe_db_snapshots).with(db_instance_identifier: db_instance_identifier).and_return(db_snapshots)
    allow(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier)
  end

  it 'should delete all snapshots older than now matching the db_instance_id' do
    expect(SnapshotsDelete.new(config, db_instance_identifier, nil, nil, nil, nil).execute).to eq(db_snapshots)
  end

  it 'should delete all snapshots older than an hour matching the db_instance_id' do
    expect(SnapshotsDelete.new(config, db_instance_identifier, hours, nil, nil, nil).execute).to eq(db_snapshots)
  end

  it 'should delete all snapshots older than a day matching the db_instance_id' do
    expect(SnapshotsDelete.new(config, db_instance_identifier, nil, days, nil, nil).execute).to eq(db_snapshots)
  end

  it 'should delete all snapshots older than a month matching the db_instance_id' do
    expect(SnapshotsDelete.new(config, db_instance_identifier, nil, nil, months, nil).execute).to eq(db_snapshots)
  end

  it 'should delete all snapshots older than a year matching the db_instance_id' do
    expect(SnapshotsDelete.new(config, db_instance_identifier, nil, nil, nil, years).execute).to eq(db_snapshots)
  end

end