require 'aws_helpers/rds'

describe AwsHelpers::RDS do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(AwsHelpers::Config) }

  describe '#initialize' do

    it 'should call AwsHelpers::Client initialize method' do
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::RDS.new(options)
    end

  end


  describe '#snapshot_create' do

    let(:snapshot_create) { double(SnapshotCreate) }

    let(:db_instance_id) { 'my_instance_id' }
    let(:default_use_name) { false }
    let(:use_name) { true }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(SnapshotCreate).to receive(:new).with(anything, anything, anything).and_return(snapshot_create)
      allow(snapshot_create).to receive(:execute)
    end

    it 'should create SnapshotCreate with default parameters' do
      expect(SnapshotCreate).to receive(:new).with(config, db_instance_id, default_use_name)
      AwsHelpers::RDS.new(options).snapshot_create(db_instance_id: db_instance_id)
    end

    it 'should call SnapshotCreate execute method' do
      expect(snapshot_create).to receive(:execute)
      AwsHelpers::RDS.new(options).snapshot_create(db_instance_id: db_instance_id)
    end

    context 'call SnapshotCreate with use_name' do

      it 'should create SanpshotCreate with use name set to true' do
        expect(SnapshotCreate).to receive(:new).with(config, db_instance_id, true)
        AwsHelpers::RDS.new(options).snapshot_create(db_instance_id: db_instance_id, use_name: use_name)
      end

    end

  end

  describe '#snapshots_delete' do

    let(:snapshots_delete) { double(SnapshotsDelete) }

    let(:db_instance_id) { 'my_instance_id' }
    let(:default_days) { nil }
    let(:default_months) { nil }
    let(:default_years) { nil }

    let(:days) { 1 }
    let(:months) { 1 }
    let(:years) { 1 }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(SnapshotsDelete).to receive(:new).with(anything, anything, anything, anything, anything).and_return(snapshots_delete)
      allow(snapshots_delete).to receive(:execute)
    end

    it 'should create SnapshotsDelete with default parameters' do
      expect(SnapshotsDelete).to receive(:new).with(config, db_instance_id, default_days, default_months, default_years)
      AwsHelpers::RDS.new(options).snapshots_delete(db_instance_id: db_instance_id)
    end

    it 'should call SnapshotsDelete execute method' do
      expect(snapshots_delete).to receive(:execute)
      AwsHelpers::RDS.new(options).snapshots_delete(db_instance_id: db_instance_id)
    end

    it 'should calls ImagesDelete with days supplied' do
      expect(SnapshotsDelete).to receive(:new).with(config, db_instance_id, days, nil, nil)
      AwsHelpers::RDS.new(options).snapshots_delete(db_instance_id: db_instance_id, days: days, months: default_months, years: default_years)
    end

    it 'should calls ImagesDelete with months supplied' do
      expect(SnapshotsDelete).to receive(:new).with(config, db_instance_id, nil, months, nil)
      AwsHelpers::RDS.new(options).snapshots_delete(db_instance_id: db_instance_id, days: default_days, months: months, years: default_years)
    end

    it 'should calls SnapshotsDelete with years supplied' do
      expect(SnapshotsDelete).to receive(:new).with(config, db_instance_id, nil, nil, years)
      AwsHelpers::RDS.new(options).snapshots_delete(db_instance_id: db_instance_id, days: default_days, months: default_months, years: years)
    end

    it 'should calls SnapshotsDelete with days, months and years supplied' do
      expect(SnapshotsDelete).to receive(:new).with(config, db_instance_id, days, months, years)
      AwsHelpers::RDS.new(options).snapshots_delete(db_instance_id: db_instance_id, days: days, months: months, years: years)
    end

  end

  describe '#snapshot_latest' do

    let(:snapshot_latest) { double(SnapshotLatest) }
    let(:db_instance_id) { 'my_instance_id' }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(SnapshotLatest).to receive(:new).with(anything, anything).and_return(snapshot_latest)
      allow(snapshot_latest).to receive(:execute)
    end

    it 'should create SnapshotLatest' do
      expect(SnapshotLatest).to receive(:new).with(config, db_instance_id)
      AwsHelpers::RDS.new(options).snapshot_latest(db_instance_id: db_instance_id)
    end

    it 'should call SnapshotCreate execute method' do
      expect(snapshot_latest).to receive(:execute).and_return(snapshot_latest)
      AwsHelpers::RDS.new(options).snapshot_latest(db_instance_id: db_instance_id)
    end

  end

end
