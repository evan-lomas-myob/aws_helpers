require 'aws_helpers/rds'

describe AwsHelpers::RDS do
  let(:db_instance_id) { '987' }
  let(:snapshot_id) { '123' }
  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:create_request) { SnapshotCreateRequest.new(db_instance_id: db_instance_id) }
  let(:delete_request) { SnapshotsDeleteRequest.new(snapshot_id: snapshot_id) }
  let(:create_director) { instance_double(SnapshotCreateDirector) }
  let(:delete_director) { instance_double(SnapshotsDeleteDirector) }
  let(:latest_request) { GetLatestSnapshotIdRequest.new(snapshot_id: snapshot_id) }
  let(:latest_director) { instance_double(GetLatestSnapshotIdDirector) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }

  describe '#initialize' do
    it 'should call AwsHelpers::Client initialize method' do
      options = { endpoint: 'http://endpoint' }
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::RDS.new(options)
    end
  end

  describe '#snapshot_create' do
    before do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(SnapshotCreateRequest).to receive(:new).and_return(create_request)
      allow(SnapshotCreateDirector).to receive(:new).and_return(create_director)
      allow(create_director).to receive(:create)
    end

    it 'should create a SnapshotCreateRequest' do
      expect(SnapshotCreateRequest)
        .to receive(:new)
      AwsHelpers::RDS.new.snapshot_create(db_instance_id)
    end

    it 'should create a SnapshotCreateDirector' do
      expect(SnapshotCreateDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::RDS.new.snapshot_create(db_instance_id)
    end

    it 'should call create on the director' do
      expect(create_director)
        .to receive(:create)
        .with(create_request)
      AwsHelpers::RDS.new.snapshot_create(db_instance_id)
    end
  end

  describe '#snapshots_delete' do
    let(:time) { Time.now }

    before do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(SnapshotsDeleteRequest).to receive(:new).and_return(delete_request)
      allow(SnapshotsDeleteDirector).to receive(:new).and_return(delete_director)
      allow(delete_director).to receive(:delete)
      allow(Time).to receive(:now).and_return(time)
      allow(time).to receive(:prev_hour).and_return(time)
      allow(time).to receive(:prev_day).and_return(time)
      allow(time).to receive(:prev_month).and_return(time)
      allow(time).to receive(:prev_year).and_return(time)
    end

    it 'should set older_than when provided' do
      expect(time).to receive(:prev_year).with(1)
      expect(time).to receive(:prev_hour).with(4)
      AwsHelpers::RDS.new.snapshots_delete(db_instance_id, older_than: { hours: 4, years: 1 })
    end

    it 'should default to 14 days when not provided' do
      expect(time).to receive(:prev_day).with(14)
      AwsHelpers::RDS.new.snapshots_delete(db_instance_id)
    end

    it 'should create a SnapshotsDeleteRequest' do
      expect(SnapshotsDeleteRequest)
        .to receive(:new)
      AwsHelpers::RDS.new.snapshots_delete(db_instance_id)
    end

    it 'should create a SnapshotsDeleteDirector' do
      expect(SnapshotsDeleteDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::RDS.new.snapshots_delete(db_instance_id)
    end

    it 'should call delete on the director' do
      expect(delete_director)
        .to receive(:delete)
        .with(delete_request)
      AwsHelpers::RDS.new.snapshots_delete(db_instance_id)
    end
  end

  describe '#latest_snapshot' do
    before do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(GetLatestSnapshotIdRequest).to receive(:new).and_return(latest_request)
      allow(GetLatestSnapshotIdDirector).to receive(:new).and_return(latest_director)
      allow(latest_director).to receive(:get)
      allow(latest_request).to receive(:snapshot_id).and_return(snapshot_id)
    end

    it 'should create a GetLatestSnapshotIdRequest' do
      expect(GetLatestSnapshotIdRequest)
        .to receive(:new)
      expect(latest_request).to receive(:db_instance_id=)
      AwsHelpers::RDS.new.latest_snapshot(db_instance_id)
    end

    it 'should create a GetLatestSnapshotIdDirector' do
      expect(GetLatestSnapshotIdDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::RDS.new.latest_snapshot(db_instance_id)
    end

    it 'should return the latest id' do
      id = AwsHelpers::RDS.new.latest_snapshot(db_instance_id)
      expect(id).to eq(snapshot_id)
    end
  end
end
