require 'aws-sdk-core'

require 'aws_helpers/config'
require 'aws_helpers/actions/rds/snapshot_create'
require 'aws_helpers/actions/rds/snapshot_construct_name'
require 'aws_helpers/actions/rds/poll_snapshot_available'
require 'aws_helpers/actions/rds/poll_instance_available'

describe AwsHelpers::Actions::RDS::SnapshotCreate do
  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }
  let(:snapshot_construct_name) { instance_double(AwsHelpers::Actions::RDS::SnapshotConstructName) }
  let(:poll_instance_available) { instance_double(AwsHelpers::Actions::RDS::PollInstanceAvailable) }
  let(:poll_snapshot_available) { instance_double(AwsHelpers::Actions::RDS::PollSnapshotAvailable) }
  let(:db_instance_identifier) { 'db_instance_identifier' }
  let(:stdout) { instance_double(IO) }
  let(:snapshot_name) { 'name' }
  describe '#execute' do
    before(:each) do
      allow(AwsHelpers::Actions::RDS::PollInstanceAvailable).to receive(:new).and_return(poll_instance_available)
      allow(poll_instance_available).to receive(:execute)
      allow(AwsHelpers::Actions::RDS::SnapshotConstructName).to receive(:new).and_return(snapshot_construct_name)
      allow(snapshot_construct_name).to receive(:execute).and_return(snapshot_name)
      allow(rds_client).to receive(:create_db_snapshot)
      allow(AwsHelpers::Actions::RDS::PollSnapshotAvailable).to receive(:new).and_return(poll_snapshot_available)
      allow(poll_snapshot_available).to receive(:execute)
    end

    it 'should call PollInstanceAvailable #new with correct parameters' do
      expect(AwsHelpers::Actions::RDS::PollInstanceAvailable).to receive(:new).with(config, db_instance_identifier, {})
      AwsHelpers::Actions::RDS::SnapshotCreate.new(config, db_instance_identifier).execute
    end

    it 'should call PollInstanceAvailable #new with optional parameters' do
      expect(AwsHelpers::Actions::RDS::PollInstanceAvailable).to receive(:new).with(config, db_instance_identifier, {})
      AwsHelpers::Actions::RDS::SnapshotCreate.new(config, db_instance_identifier).execute
    end

    it 'should call PollInstanceAvailable with stdout if set in options' do
      options = { stdout: stdout }
      expect(AwsHelpers::Actions::RDS::PollInstanceAvailable).to receive(:new).with(config, db_instance_identifier, options)
      AwsHelpers::Actions::RDS::SnapshotCreate.new(config, db_instance_identifier, options).execute
    end

    it 'should call PollInstanceAvailable with max_attempts if set in options' do
      pooling_options = { max_attempts: 1 }
      options = { instance_polling: pooling_options }
      expect(AwsHelpers::Actions::RDS::PollInstanceAvailable).to receive(:new).with(config, db_instance_identifier, pooling_options)
      AwsHelpers::Actions::RDS::SnapshotCreate.new(config, db_instance_identifier, options).execute
    end

    it 'should call PollInstanceAvailable with delay if set in options' do
      pooling_options = { delay: 1 }
      options = { instance_polling: pooling_options }
      expect(AwsHelpers::Actions::RDS::PollInstanceAvailable).to receive(:new).with(config, db_instance_identifier, pooling_options)
      AwsHelpers::Actions::RDS::SnapshotCreate.new(config, db_instance_identifier, options).execute
    end

    it 'should call PollInstanceAvailable #execute' do
      expect(poll_instance_available).to receive(:execute)
      AwsHelpers::Actions::RDS::SnapshotCreate.new(config, db_instance_identifier).execute
    end

    it 'should call SnapshotConstructName #new with correct parameters' do
      expect(AwsHelpers::Actions::RDS::SnapshotConstructName).to receive(:new).with(config, db_instance_identifier, {})
      AwsHelpers::Actions::RDS::SnapshotCreate.new(config, db_instance_identifier).execute
    end

    it 'should call SnapshotConstructName #new with optional parameters use_name' do
      expect(AwsHelpers::Actions::RDS::SnapshotConstructName).to receive(:new).with(config, db_instance_identifier, use_name: true)
      AwsHelpers::Actions::RDS::SnapshotCreate.new(config, db_instance_identifier, use_name: true).execute
    end

    it 'should call SnapshotConstructName #execute' do
      expect(snapshot_construct_name).to receive(:execute)
      AwsHelpers::Actions::RDS::SnapshotCreate.new(config, db_instance_identifier).execute
    end

    it 'should call Aws::RDS::Client #create_db_snapshot with correct parameters' do
      expect(rds_client)
        .to receive(:create_db_snapshot)
        .with(db_instance_identifier: db_instance_identifier, db_snapshot_identifier: snapshot_name)
      AwsHelpers::Actions::RDS::SnapshotCreate.new(config, db_instance_identifier).execute
    end

    it 'should call PollSnapshotAvailable #new with correct parameters' do
      expect(AwsHelpers::Actions::RDS::PollSnapshotAvailable)
        .to receive(:new)
        .with(config, snapshot_name, {})
      AwsHelpers::Actions::RDS::SnapshotCreate.new(config, db_instance_identifier).execute
    end

    it 'should call PollSnapshotAvailable with stdout if set in options' do
      options = { stdout: stdout }
      expect(AwsHelpers::Actions::RDS::PollSnapshotAvailable).to receive(:new).with(config, snapshot_name, options)
      AwsHelpers::Actions::RDS::SnapshotCreate.new(config, db_instance_identifier, options).execute
    end

    it 'should call PollSnapshotAvailable with max_attempts if set in options' do
      pooling_options = { max_attempts: 1 }
      options = { snapshot_polling: pooling_options }
      expect(AwsHelpers::Actions::RDS::PollSnapshotAvailable).to receive(:new).with(config, snapshot_name, pooling_options)
      AwsHelpers::Actions::RDS::SnapshotCreate.new(config, db_instance_identifier, options).execute
    end

    it 'should call PollSnapshotAvailable with delay if set in options' do
      pooling_options = { delay: 1 }
      options = { snapshot_polling: pooling_options }
      expect(AwsHelpers::Actions::RDS::PollSnapshotAvailable).to receive(:new).with(config, snapshot_name, pooling_options)
      AwsHelpers::Actions::RDS::SnapshotCreate.new(config, db_instance_identifier, options).execute
    end

    it 'should call AwsHelpers::Actions::RDS::PollDBSnapshot #execute' do
      expect(poll_snapshot_available).to receive(:execute)
      AwsHelpers::Actions::RDS::SnapshotCreate.new(config, db_instance_identifier).execute
    end
  end
end
