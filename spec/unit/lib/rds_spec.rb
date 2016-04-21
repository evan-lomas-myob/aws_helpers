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
      # allow(SnapshotCreateRequest).to receive(:new).and_return(create_request)
      # allow(SnapshotCreateDirector).to receive(:new).and_return(create_director)
    end

    it 'should create a SnapshotCreateRequest' do
      expect(SnapshotCreateRequest)
        .to receive(:new)
        .with(db_instance_id: db_instance_id)
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
    before do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(SnapshotsDeleteRequest).to receive(:new).and_return(delete_request)
      allow(SnapshotsDeleteDirector).to receive(:new).and_return(delete_director)
      allow(delete_director).to receive(:delete)
      # allow(SnapshotsDeleteRequest).to receive(:new).and_return(delete_request)
      # allow(SnapshotsDeleteDirector).to receive(:new).and_return(delete_director)
    end

    it 'should create a SnapshotsDeleteRequest' do
      expect(SnapshotsDeleteRequest)
        .to receive(:new)
        .with(db_instance_id: db_instance_id, time_options: {})
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
      allow(latest_director).to receive(:get).and_return(snapshot_id)
    end

    it 'should create a GetLatestSnapshotIdRequest' do
      expect(GetLatestSnapshotIdRequest)
        .to receive(:new)
        .with(db_instance_id: db_instance_id)
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
  #   let(:snapshots_delete) { instance_double(SnapshotsDelete) }

  #   let(:hours) { 1 }
  #   let(:days) { 2 }
  #   let(:months) { 3 }
  #   let(:years) { 4 }

  #   before(:each) do
  #     allow(AwsHelpers::Config).to receive(:new).and_return(config)
  #     allow(SnapshotsDelete).to receive(:new).and_return(snapshots_delete)
  #     allow(snapshots_delete).to receive(:execute)
  #   end

  #   it 'should call SnapshotsDelete #new with correct parameters' do
  #     expect(SnapshotsDelete).to receive(:new).with(config, db_instance_id, {})
  #     AwsHelpers::RDS.new.snapshots_delete(db_instance_id)
  #   end

  #   it 'should call SnapshotsDelete #new with optional hours' do
  #     expect(SnapshotsDelete).to receive(:new).with(config, db_instance_id, hours: hours)
  #     AwsHelpers::RDS.new.snapshots_delete(db_instance_id, hours: hours)
  #   end

  #   it 'should call SnapshotsDelete #new with optional days' do
  #     expect(SnapshotsDelete).to receive(:new).with(config, db_instance_id, days: days)
  #     AwsHelpers::RDS.new.snapshots_delete(db_instance_id, days: days)
  #   end

  #   it 'should call SnapshotsDelete #new with optional months' do
  #     expect(SnapshotsDelete).to receive(:new).with(config, db_instance_id, months: months)
  #     AwsHelpers::RDS.new.snapshots_delete(db_instance_id, months: months)
  #   end

  #   it 'should call SnapshotsDelete #new with optional years' do
  #     expect(SnapshotsDelete).to receive(:new).with(config, db_instance_id, years: years)
  #     AwsHelpers::RDS.new.snapshots_delete(db_instance_id, years: years)
  #   end

  #   it 'should call SnapshotsDelete #execute method' do
  #     expect(snapshots_delete).to receive(:execute)
  #     AwsHelpers::RDS.new.snapshots_delete(db_instance_id)
  #   end
  # end

  # describe '#latest_snapshot' do
  #   let(:snapshot_id) { 'snapshot_id' }
  #   let(:latest_snapshot) { instance_double(LatestSnapshot) }

  #   before(:each) do
  #     allow(AwsHelpers::Config).to receive(:new).and_return(config)
  #     allow(LatestSnapshot).to receive(:new).and_return(latest_snapshot)
  #     allow(latest_snapshot).to receive(:execute).and_return(snapshot_id)
  #   end

  #   subject { AwsHelpers::RDS.new.latest_snapshot(db_instance_id) }

  #   it 'should create SnapshotLatest with correct parameters' do
  #     expect(LatestSnapshot).to receive(:new).with(config, db_instance_id)
  #     subject
  #   end

  #   it 'should call SnapshotsDelete execute method' do
  #     expect(latest_snapshot).to receive(:execute)
  #     subject
  #   end

  #   it 'should return the latest snapshot id' do
  #     expect(subject).to be(snapshot_id)
  #   end
  # end
end
