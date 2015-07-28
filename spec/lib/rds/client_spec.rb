require 'rspec'
require 'aws_helpers/rds/client'
require 'aws_helpers/rds/snapshot'

describe AwsHelpers::RDS::Client do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  describe '.new' do

    it "should call AwsHelpers::RDS::Client's initialize method" do
      expect(AwsHelpers::RDS::Client).to receive(:new).with(options)
      AwsHelpers::RDS::Client.new(options)
    end

  end

  describe 'RDS Config methods' do

    it 'should create an instance of Aws::RDS::Client' do
      expect(AwsHelpers::RDS::Config.new(options).aws_rds_client).to match(Aws::RDS::Client)
    end

    it 'should create an instance of Aws::IAM::Client' do
      expect(AwsHelpers::RDS::Config.new(options).aws_iam_client).to match(Aws::IAM::Client)
    end

  end

  describe 'RDS Client Snapshot Methods' do

    let(:aws_rds_client) { Aws::RDS::Client }
    let(:aws_iam_client) { Aws::IAM::Client }
    let(:db_instance_id) { 12345 }
    let(:use_name) { false }

    let(:rds_client) { double(AwsHelpers::RDS::Snapshot.new(aws_rds_client, aws_iam_client, db_instance_id, use_name)) }

    it 'should return a instance of Snapshot' do
      expect(AwsHelpers::RDS::Snapshot.new(aws_rds_client, aws_iam_client, db_instance_id, use_name)).to match(AwsHelpers::RDS::Snapshot)
    end

    it 'should create a snapshot using a db instance id' do
      allow(rds_client).to receive(:create)
      expect(AwsHelpers::RDS::Snapshot).to receive(:new).with(aws_rds_client, aws_iam_client, db_instance_id, use_name).and_return(rds_client)
      AwsHelpers::RDS::Client.new(options).snapshot_create(db_instance_id, use_name)
    end

    it 'should delete a snapshot using a db instance id' do
      allow(rds_client).to receive(:delete)
      expect(AwsHelpers::RDS::Snapshot).to receive(:new).with(aws_rds_client, aws_iam_client, db_instance_id).and_return(rds_client)
      AwsHelpers::RDS::Client.new(options).snapshots_delete(db_instance_id)
    end

    it 'should delete a snapshot using a db instance id and a set of options' do
      allow(rds_client).to receive(:delete)
      expect(AwsHelpers::RDS::Snapshot).to receive(:new).with(aws_rds_client, aws_iam_client, db_instance_id).and_return(rds_client)
      AwsHelpers::RDS::Client.new(options).snapshots_delete(db_instance_id, options)
    end

    it 'should return the latest snapshot matching the db instance id' do
      allow(rds_client).to receive(:latest)
      expect(AwsHelpers::RDS::Snapshot).to receive(:new).with(aws_rds_client, aws_iam_client, db_instance_id).and_return(rds_client)
      AwsHelpers::RDS::Client.new(options).snapshot_latest(db_instance_id)
    end

  end

end