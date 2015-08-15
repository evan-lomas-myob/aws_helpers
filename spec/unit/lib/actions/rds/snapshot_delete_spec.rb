require 'aws_helpers/utilities/subtract_time'
require 'aws_helpers/actions/rds/snapshots_delete'

describe AwsHelpers::Actions::RDS::SnapshotsDelete do

  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }
  let(:stdout) { instance_double(IO) }

  let(:subtract_time) { instance_double(AwsHelpers::Utilities::SubtractTime) }
  let(:db_instance_id) { 'db_instance_id' }
  let(:now) { Time.parse('2015 Jan 1 00:00:00') }
  let(:db_snapshot_identifier_first) { 'id_first' }
  let(:db_snapshot_identifier_second) { 'id_second' }
  let(:snapshots) {
    Aws::RDS::Types::DBSnapshotMessage.new(
      db_snapshots: [
        Aws::RDS::Types::DBSnapshot.new(
          db_snapshot_identifier: db_snapshot_identifier_second,
          snapshot_create_time: now),
        Aws::RDS::Types::DBSnapshot.new(
          db_snapshot_identifier: 'id_third',
          snapshot_create_time: Time.parse('2015 Jan 1 00:00:01')),
        Aws::RDS::Types::DBSnapshot.new(
          db_snapshot_identifier: db_snapshot_identifier_first,
          snapshot_create_time: now - 1)
      ])
  }

  before(:each) {
    allow(rds_client).to receive(:describe_db_snapshots).and_return(snapshots)
    allow(AwsHelpers::Utilities::SubtractTime).to receive(:new).and_return(subtract_time)
    allow(subtract_time).to receive(:execute).and_return(now)
    allow(rds_client).to receive(:delete_db_snapshot)
    allow(stdout).to receive(:puts)
  }

  describe '#execute' do

    it 'should call Aws::RDS::Client #describe_db_snapshots with correct parameters' do
      expect(rds_client).to receive(:describe_db_snapshots).with(db_instance_identifier: db_instance_id, snapshot_type: 'manual')
      AwsHelpers::Actions::RDS::SnapshotsDelete.new(config, db_instance_id, stdout: stdout).execute
    end

    it 'should call AwsHelpers::Utilities::SubtractTime #new with correct parameters' do
      options = { stdout: stdout, hours: 1, days: 2, months: 3, years: 4 }
      expect(AwsHelpers::Utilities::SubtractTime).to receive(:new).with(hours: 1, days: 2, months: 3, years: 4)
      AwsHelpers::Actions::RDS::SnapshotsDelete.new(config, db_instance_id, options).execute
    end

    it 'should call AwsHelpers::Utilities::SubtractTime #execute method' do
      expect(subtract_time).to receive(:execute)
      AwsHelpers::Actions::RDS::SnapshotsDelete.new(config, db_instance_id, stdout: stdout).execute
    end

    it 'should call Aws::RDS::Client #delete_db_snapshot with correct parameters for the first db_snapshot_identifier' do
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: db_snapshot_identifier_first)
      AwsHelpers::Actions::RDS::SnapshotsDelete.new(config, db_instance_id, stdout: stdout).execute
    end

    it 'should call stdout with the snapshots being deleted' do
      expect(stdout).to receive(:puts).with("Deleting Snapshot=#{db_snapshot_identifier_second}, Created=#{now}")
      AwsHelpers::Actions::RDS::SnapshotsDelete.new(config, db_instance_id, stdout: stdout).execute
    end

    it 'should call delete from oldest to newest' do
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: db_snapshot_identifier_first).ordered
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: db_snapshot_identifier_second).ordered
      AwsHelpers::Actions::RDS::SnapshotsDelete.new(config, db_instance_id, stdout: stdout).execute
    end

  end

end