require 'aws-sdk-core'

require 'aws_helpers/config'
require 'aws_helpers/actions/rds/snapshots_delete'
require 'aws_helpers/utilities/time'

describe AwsHelpers::Actions::RDS::SnapshotsDelete do

  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }
  let(:stdout) { instance_double(IO) }

  let(:db_instance_id) { 'db_instance_id' }
  let(:now) { Time.parse('2015 Jan 1 00:00:00') }
  let(:db_snapshot_identifier_first) { 'id_first' }
  let(:db_snapshot_identifier_second) { 'id_second' }

  let(:snapshots) {
    [
      Aws::RDS::Types::DBSnapshot.new(
        db_snapshot_identifier: '1',
        snapshot_create_time: now.prev_year(1)),
      Aws::RDS::Types::DBSnapshot.new(
        db_snapshot_identifier: '2',
        snapshot_create_time: now.prev_month(1)),
      Aws::RDS::Types::DBSnapshot.new(
        db_snapshot_identifier: '3',
        snapshot_create_time: now.prev_day(1)),
      Aws::RDS::Types::DBSnapshot.new(
        db_snapshot_identifier: '4',
        snapshot_create_time: now.prev_hour(1)),
      Aws::RDS::Types::DBSnapshot.new(
        db_snapshot_identifier: '5',
        snapshot_create_time: now)
    ].shuffle
  }
  let(:response) { Aws::RDS::Types::DBSnapshotMessage.new(
    db_snapshots: snapshots)
  }

  describe '#execute' do

    before(:each) {
      allow(rds_client).to receive(:describe_db_snapshots).and_return(response)
      allow(stdout).to receive(:puts)
    }

    it 'should call Aws::RDS::Client #describe_db_snapshots with correct parameters' do
      allow(rds_client).to receive(:delete_db_snapshot)
      expect(rds_client).to receive(:describe_db_snapshots).with(db_instance_identifier: db_instance_id, snapshot_type: 'manual')
      AwsHelpers::Actions::RDS::SnapshotsDelete.new(config, db_instance_id, stdout: stdout).execute
    end

    it 'should only delete snapshots from one years ago' do
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: '1')
      AwsHelpers::Actions::RDS::SnapshotsDelete.new(config, db_instance_id, stdout: stdout, time: now, years: 1).execute
    end

    it 'should only delete snapshots from one month ago' do
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: '1')
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: '2')
      AwsHelpers::Actions::RDS::SnapshotsDelete.new(config, db_instance_id, stdout: stdout, time: now, months: 1).execute
    end

    it 'should only delete snapshots from one day ago' do
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: '1')
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: '2')
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: '3')
      AwsHelpers::Actions::RDS::SnapshotsDelete.new(config, db_instance_id, stdout: stdout, time: now, days: 1).execute
    end

    it 'should only delete snapshots from one hour ago' do
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: '1')
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: '2')
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: '3')
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: '4')
      AwsHelpers::Actions::RDS::SnapshotsDelete.new(config, db_instance_id, stdout: stdout, time: now, hours: 1).execute
    end

    it 'should call delete from oldest to newest' do
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: '1').ordered
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: '2').ordered
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: '3').ordered
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: '4').ordered
      expect(rds_client).to receive(:delete_db_snapshot).with(db_snapshot_identifier: '5').ordered
      AwsHelpers::Actions::RDS::SnapshotsDelete.new(config, db_instance_id, stdout: stdout).execute
    end

    it 'should call stdout with the snapshots being deleted' do
      allow(rds_client).to receive(:delete_db_snapshot)
      expect(stdout).to receive(:puts).with("Deleting Snapshot=5, Created=#{now}")
      AwsHelpers::Actions::RDS::SnapshotsDelete.new(config, db_instance_id, stdout: stdout).execute
    end

  end

end