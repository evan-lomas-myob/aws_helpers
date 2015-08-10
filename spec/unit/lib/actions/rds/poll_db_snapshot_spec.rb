require 'aws_helpers/config'
require 'aws_helpers/actions/rds/poll_db_snapshot'

include AwsHelpers
include AwsHelpers::Actions::RDS

describe PollDBSnapshot do

  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:iam_client) { instance_double(Aws::IAM::Client) }

  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client, aws_iam_client: iam_client) }
  let(:stdout) { instance_double(IO) }

  let(:db_snapshot_identifier) { 'my_snapshot_name' }

  let(:status_creating) { 'creating' }
  let(:status_available) { 'available' }
  let(:status_deleting) { 'deleting' }

  let(:db_snapshots_creating) { [double(:db_snaphots, db_snapshot_identifier: db_snapshot_identifier, status: status_creating, percent_progress: 5)] }
  let(:db_snapshots_available) { [double(:db_snaphots, db_snapshot_identifier: db_snapshot_identifier, status: status_available, percent_progress: 100)] }
  let(:db_snapshots_deleting) { [double(:db_snaphots, db_snapshot_identifier: db_snapshot_identifier, status: status_deleting, percent_progress: 100)] }

  let(:sleep_time) { 0 }

  context 'db snapshot succeeds' do

    before(:each) do
      allow(rds_client).to receive(:describe_db_snapshots).with(db_snapshot_identifier: db_snapshot_identifier).and_return(db_snapshots_available)
      allow(stdout).to receive(:puts).with("Snapshot #{db_snapshot_identifier} available, progress 100%")
      allow(stdout).to receive(:puts).with("Snapshot #{db_snapshot_identifier} creation completed")
    end

    after(:each) do
      PollDBSnapshot.new(stdout, config, db_snapshot_identifier, sleep_time).execute
    end

    it 'should describe the snapshot using the snapshot identifier' do
      expect(rds_client).to receive(:describe_db_snapshots).with(db_snapshot_identifier: db_snapshot_identifier).and_return(db_snapshots_available)
    end

    it 'should check the status until it reaches available' do
      expect(stdout).to receive(:puts).with("Snapshot #{db_snapshot_identifier} creation completed")
    end

  end

  context 'call twice' do

    it 'should check the status is creating then available' do
      allow(rds_client).to receive(:describe_db_snapshots).with(db_snapshot_identifier: db_snapshot_identifier).and_return(db_snapshots_creating, db_snapshots_available)
      allow(stdout).to receive(:puts).with("Snapshot #{db_snapshot_identifier} creating, progress 5%")
      allow(stdout).to receive(:puts).with("Snapshot #{db_snapshot_identifier} available, progress 100%")
      expect(stdout).to receive(:puts).with("Snapshot #{db_snapshot_identifier} creation completed")
      PollDBSnapshot.new(stdout, config, db_snapshot_identifier, sleep_time).execute
    end

    it 'should check the status is creating then deleting' do
      allow(rds_client).to receive(:describe_db_snapshots).with(db_snapshot_identifier: db_snapshot_identifier).and_return(db_snapshots_creating, db_snapshots_deleting)
      allow(stdout).to receive(:puts).with("Snapshot #{db_snapshot_identifier} creating, progress 5%")
      expect { PollDBSnapshot.new(stdout, config, db_snapshot_identifier, sleep_time).execute }.to raise_error("Failed to create snapshot #{db_snapshot_identifier}")
    end

  end

end