require 'aws_helpers/rds'

describe AwsHelpers::RDS do

  let(:config) { instance_double(AwsHelpers::Config) }
  let(:db_instance_id) { 'instance_id' }

  describe '#initialize' do

    it 'should call AwsHelpers::Client initialize method' do
      options = { endpoint: 'http://endpoint' }
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::RDS.new(options)
    end

  end

  describe '#snapshot_create' do

    let(:snapshot_create) { double(SnapshotCreate) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(SnapshotCreate).to receive(:new).and_return(snapshot_create)
      allow(snapshot_create).to receive(:execute)
    end

    it 'should create SnapshotCreate #new with correct parameters' do
      expect(SnapshotCreate).to receive(:new).with(config, db_instance_id, false)
      AwsHelpers::RDS.new.snapshot_create(db_instance_id)
    end

    it 'should call SnapshotCreate #new execute method' do
      expect(snapshot_create).to receive(:execute)
      AwsHelpers::RDS.new.snapshot_create(db_instance_id)
    end

    it 'should call SanpshotCreate #new with use_name set correctly' do
      expect(SnapshotCreate).to receive(:new).with(config, db_instance_id, true)
      AwsHelpers::RDS.new.snapshot_create(db_instance_id, true)
    end


  end

  describe '#snapshots_delete' do

    let(:snapshots_delete) { double(SnapshotsDelete) }

    let(:hours) { 1 }
    let(:days) { 2 }
    let(:months) { 3 }
    let(:years) { 4 }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(SnapshotsDelete).to receive(:new).and_return(snapshots_delete)
      allow(snapshots_delete).to receive(:execute)
    end

    it 'should call SnapshotsDelete #new with correct parameters' do
      expect(SnapshotsDelete).to receive(:new).with(config, db_instance_id, {})
      AwsHelpers::RDS.new.snapshots_delete(db_instance_id)
    end

    it 'should call SnapshotsDelete #new with optional hours' do
      expect(SnapshotsDelete).to receive(:new).with(config, db_instance_id, hours: hours)
      AwsHelpers::RDS.new.snapshots_delete(db_instance_id, hours: hours)
    end

    it 'should call SnapshotsDelete #new with optional days' do
      expect(SnapshotsDelete).to receive(:new).with(config, db_instance_id, days: days)
      AwsHelpers::RDS.new.snapshots_delete(db_instance_id, days: days)
    end

    it 'should call SnapshotsDelete #new with optional months' do
      expect(SnapshotsDelete).to receive(:new).with(config, db_instance_id, months: months)
      AwsHelpers::RDS.new.snapshots_delete(db_instance_id, months: months)
    end

    it 'should call SnapshotsDelete #new with optional years' do
      expect(SnapshotsDelete).to receive(:new).with(config, db_instance_id, years: years)
      AwsHelpers::RDS.new.snapshots_delete(db_instance_id, years: years)
    end

    it 'should call SnapshotsDelete #execute method' do
      expect(snapshots_delete).to receive(:execute)
      AwsHelpers::RDS.new.snapshots_delete(db_instance_id)
    end

  end

  describe '#latest_snapshot' do

    let(:snapshot_id) { 'snapshot_id' }
    let(:latest_snapshot) { instance_double(LatestSnapshot) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(LatestSnapshot).to receive(:new).and_return(latest_snapshot)
      allow(latest_snapshot).to receive(:execute).and_return(snapshot_id)
    end

    subject { AwsHelpers::RDS.new.latest_snapshot(db_instance_id) }

    it 'should create SnapshotLatest with correct parameters' do
      expect(LatestSnapshot).to receive(:new).with(config, db_instance_id)
      subject
    end

    it 'should call SnapshotCreate execute method' do
      expect(latest_snapshot).to receive(:execute)
      subject
    end

    it 'should return the latest snapshot id' do
      expect(subject).to be(snapshot_id)
    end

  end

end
