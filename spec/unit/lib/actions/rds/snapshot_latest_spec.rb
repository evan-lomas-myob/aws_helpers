require 'aws_helpers/rds'
require 'aws_helpers/actions/rds/snapshot_latest'

include AwsHelpers
include AwsHelpers::Actions::RDS

describe SnapshotLatest do

  describe '#execute' do

    let(:rds_client) { instance_double(Aws::RDS::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }

    let(:db_instance_identifier) { 'db_instance_id' }

    let(:db_snapshot_identifier_oldest) { 'oldest' }
    let(:db_snapshot_identifier_latest) { 'newest' }

    let(:db_snapshots) {
      [
          double(:db_snapshots, db_snapshot_identifier: db_snapshot_identifier_oldest, snapshot_create_time: '2005-02-01 12:00' ),
          double(:db_snapshots, db_snapshot_identifier: db_snapshot_identifier_latest, snapshot_create_time: '2005-02-01 12:10' )
      ]
    }

    it 'should return the name of the latest snapshot' do
      allow(rds_client).to receive(:describe_db_snapshots).with(db_instance_identifier: db_instance_identifier).and_return(db_snapshots)
      expect(SnapshotLatest.new(config, db_instance_identifier).execute).to be(db_snapshot_identifier_latest)
    end

  end
end