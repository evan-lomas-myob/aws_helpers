require 'aws_helpers/rds'
require 'aws_helpers/actions/rds/snapshot_create'
require 'aws_helpers/actions/rds/snapshot_construct_name'
require 'aws_helpers/actions/rds/poll_db_snapshot'

include AwsHelpers
include AwsHelpers::Actions::RDS

describe SnapshotCreate do

  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:iam_client) { instance_double(Aws::IAM::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client, aws_iam_client: iam_client) }
  let(:snapshot_construct_name) { instance_double(SnapshotConstructName) }
  let(:poll_db_snapshots) { instance_double(PollDBSnapshot) }
  let(:stdout) { instance_double(IO) }

  let(:db_instance_identifier) { 'db_instance_id' }
  let(:db_snapshot_identifier) { 'my_snapshot_name' }
  let(:db_instance_name) { 'my_db_instance_name' }

  let(:now) { Time.parse('01-Jan-2015').strftime('%Y-%m-%d-%H-%M') }
  let(:db_snapshot_name_when_true) { "#{db_instance_name}-" + now }
  let(:db_snapshot_name_when_false) { "#{db_instance_identifier}-" + now }

  let(:rds_configuration) { double(region: 'my_region') }

  let(:iam_user_id) { '123456789012' }
  let(:iam_user_arn) { 'arn:aws:iam::123456789012:user' }
  let(:user_list) { [double(:user_list, arn: iam_user_arn)] }

  let(:status_available) { 'available' }

  let(:resource_name) { "arn:aws:rds:#{rds_configuration.region}:#{iam_user_id}:db:#{db_instance_identifier}" }
  let(:db_snapshots_available) { [double(:db_snaphots, db_snapshot_identifier: db_snapshot_identifier, status: status_available, percent_progress: 100)] }

  let(:tag_list) { [double(:tag_list, key: 'Name', value: db_instance_name)] }

  let(:use_name) { true }

  before(:each) do
    allow(iam_client).to receive(:config).and_return(rds_configuration)
    allow(iam_client).to receive(:list_users).and_return(user_list)
    allow(rds_client).to receive(:list_tags_for_resource).with(resource_name).and_return(tag_list)
  end

  context 'use_name is true' do

    after(:each) do
      SnapshotCreate.new(stdout, config, db_instance_identifier, use_name, now).execute
    end

    it 'should call SnapshotConstructName to name snapshot' do
      allow(rds_client).to receive(:describe_db_snapshots).with(db_snapshot_identifier: db_snapshot_name_when_true).and_return(db_snapshots_available)
      expect(SnapshotConstructName.new(config, db_instance_identifier).execute).to eq(db_instance_name)
      allow(rds_client).to receive(:create_db_snapshot).with(db_instance_identifier: db_instance_identifier, db_snapshot_identifier: db_snapshot_name_when_true)
      allow(stdout).to receive(:puts).with("Snapshot #{db_snapshot_name_when_true} creation completed")
    end

    it 'should call create_db_snapshot to create the snapshot with use_name true' do
      allow(rds_client).to receive(:describe_db_snapshots).with(db_snapshot_identifier: db_snapshot_name_when_true).and_return(db_snapshots_available)
      expect(rds_client).to receive(:create_db_snapshot).with(db_instance_identifier: db_instance_identifier, db_snapshot_identifier: db_snapshot_name_when_true)
      allow(stdout).to receive(:puts).with("Snapshot #{db_snapshot_name_when_true} creation completed")
    end

  end

  context 'use_name is false' do

    it 'should call create_db_snapshot to create the snapshot with use_name false' do
      use_name = false
      allow(rds_client).to receive(:describe_db_snapshots).with(db_snapshot_identifier: db_snapshot_name_when_false).and_return(db_snapshots_available)
      expect(rds_client).to receive(:create_db_snapshot).with(db_instance_identifier: db_instance_identifier, db_snapshot_identifier: db_snapshot_name_when_false)
      allow(stdout).to receive(:puts).with("Snapshot #{db_snapshot_name_when_false} creation completed")
      SnapshotCreate.new(stdout, config, db_instance_identifier, use_name, now).execute
    end

  end

end