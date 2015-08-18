require 'aws_helpers/rds'
require 'aws_helpers/actions/rds/latest_snapshot'

describe AwsHelpers::Actions::RDS::LatestSnapshot do

  describe '#execute' do

    let(:rds_client) { instance_double(Aws::RDS::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }

    let(:db_instance_identifier) { 'db_instance_id' }
    let(:db_snapshot_identifier_oldest) { 'oldest' }
    let(:db_snapshot_identifier_latest) { 'newest' }

    let(:response) {
      Aws::RDS::Types::DBSnapshotMessage.new(
        db_snapshots: [
          Aws::RDS::Types::DBSnapshot.new(db_snapshot_identifier: db_snapshot_identifier_oldest, snapshot_create_time: '2005-02-01 12:00'),
          Aws::RDS::Types::DBSnapshot.new(db_snapshot_identifier: db_snapshot_identifier_latest, snapshot_create_time: '2005-02-01 12:10')
        ])
    }

    it 'should return the name of the latest snapshot' do
      allow(rds_client).to receive(:describe_db_snapshots).with(db_instance_identifier: db_instance_identifier).and_return(response)
      expect(AwsHelpers::Actions::RDS::LatestSnapshot.new(config, db_instance_identifier).execute).to be(db_snapshot_identifier_latest)
    end

  end
end