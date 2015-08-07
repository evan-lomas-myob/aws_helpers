require 'aws_helpers/rds'
require 'aws_helpers/actions/rds/snapshot_create'
require 'aws_helpers/actions/rds/snapshot_construct_name'

include AwsHelpers
include AwsHelpers::Actions::RDS

describe SnapshotCreate do

  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:iam_client) { instance_double(Aws::IAM::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client, aws_iam_client: iam_client) }
  let(:snapshot_construct_name) { instance_double(SnapshotConstructName) }

  let(:db_instance_identifier) { 'db_instance_id' }
  let(:db_instance_name) { 'my_db_instance_name' }

  let(:db_snapshot_name_when_true) { db_instance_name }
  let(:db_snapshot_name_when_false) { 'db_instance_id-2015-01-01-00-00' }

  let(:rds_configuration) { double(region: 'my_region') }

  let(:iam_user_id) { '123456789012' }
  let(:iam_user_arn) { 'arn:aws:iam::123456789012:user' }
  let(:user_list) { [double(:user_list, arn: iam_user_arn)] }

  let(:resource_name) { "arn:aws:rds:#{rds_configuration.region}:#{iam_user_id}:db:#{db_instance_identifier}" }

  let(:tag_list) { [double(:tag_list, key: 'Name', value: db_instance_name)] }

  let(:now) { Time.parse('01-Jan-2015').strftime('%Y-%m-%d-%H-%M') }

  let(:use_name) { true }

  it 'should call SnapshotConstructName to name snapshot' do
    allow(rds_client).to receive(:create_db_snapshot).with(db_instance_identifier: db_instance_identifier, db_snapshot_identifier: db_snapshot_name_when_false)
    allow(SnapshotConstructName).to receive(:new).with(config, db_instance_identifier).and_return(snapshot_construct_name)
    expect(snapshot_construct_name).to receive(:execute)
    SnapshotCreate.new(config, db_instance_identifier, use_name, now).execute
  end

  it 'should call create_db_snapshot to create the snapshot with use_name true' do
    allow(iam_client).to receive(:config).and_return(rds_configuration)
    allow(iam_client).to receive(:list_users).and_return(user_list)
    allow(rds_client).to receive(:list_tags_for_resource).with(resource_name).and_return(tag_list)
    expect(rds_client).to receive(:create_db_snapshot).with(db_instance_identifier: db_instance_identifier, db_snapshot_identifier: db_snapshot_name_when_true)
    SnapshotCreate.new(config, db_instance_identifier, use_name, now).execute
  end

  it 'should call create_db_snapshot to create the snapshot with use_name false' do
    use_name = false
    allow(iam_client).to receive(:config).and_return(rds_configuration)
    allow(iam_client).to receive(:list_users).and_return(user_list)
    allow(rds_client).to receive(:list_tags_for_resource).with(resource_name).and_return(tag_list)
    expect(rds_client).to receive(:create_db_snapshot).with(db_instance_identifier: db_instance_identifier, db_snapshot_identifier: db_snapshot_name_when_false)
    SnapshotCreate.new(config, db_instance_identifier, use_name, now).execute
  end

end