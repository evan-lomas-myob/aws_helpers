require 'rspec'
require 'aws_helpers/rds/client'
require 'aws_helpers/rds/snapshot'

describe AwsHelpers::RDS::Client do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  describe '.new' do

    it "should call AwsHelpers::RDS::Client's initialize method" do
      expect(AwsHelpers::RDS::Client).to receive(:new).with(options).and_return(AwsHelpers::RDS::Config)
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

  describe 'New RDS Client Snapshot' do

    let(:aws_rds_client) { double }
    let(:aws_iam_client) { double }
    let(:db_instance_id) { 12345 }
    let(:use_name) { false }

    it 'should return a instance of Snapshot' do
      expect(AwsHelpers::RDS::Snapshot.new(aws_rds_client, aws_iam_client, db_instance_id, use_name)).to match(AwsHelpers::RDS::Snapshot)
    end
  end

  describe 'RDS Client Snapshot Methods' do

    let(:db_instance_id) { 12345 }
    let(:use_name) { false }

    let(:config) { double(aws_rds_client: double, aws_iam_client: double) }
    let(:rds_client) { double(AwsHelpers::RDS::Snapshot.new(config.aws_rds_client, config.aws_iam_client, db_instance_id, use_name)) }

    before(:each) do
      allow(AwsHelpers::RDS::Config).to receive(:new).with(options).and_return(config)
    end

    context '#create' do
      it 'should create a snapshot using a db instance id' do
        allow(AwsHelpers::RDS::Snapshot).to receive(:new).with(config.aws_rds_client, config.aws_iam_client, db_instance_id, use_name).and_return(rds_client)
        expect(rds_client).to receive(:create)
        AwsHelpers::RDS::Client.new(options).snapshot_create(db_instance_id, use_name)
      end
    end

    context '#delete' do
      it 'should delete a snapshot using a db instance id' do
        allow(AwsHelpers::RDS::Snapshot).to receive(:new).with(config.aws_rds_client, config.aws_iam_client, db_instance_id).and_return(rds_client)
        allow(rds_client).to receive(:delete)
        AwsHelpers::RDS::Client.new(options).snapshots_delete(db_instance_id)
      end

      it 'should delete a snapshot using a db instance id and a set of options' do
        allow(AwsHelpers::RDS::Snapshot).to receive(:new).with(config.aws_rds_client, config.aws_iam_client, db_instance_id).and_return(rds_client)
        allow(rds_client).to receive(:delete)
        AwsHelpers::RDS::Client.new(options).snapshots_delete(db_instance_id, options)
      end
    end

    context '#latest' do
      it 'should return the latest snapshot matching the db instance id' do
        allow(AwsHelpers::RDS::Snapshot).to receive(:new).with(config.aws_rds_client, config.aws_iam_client, db_instance_id).and_return(rds_client)
        allow(rds_client).to receive(:latest)
        AwsHelpers::RDS::Client.new(options).snapshot_latest(db_instance_id)
      end
    end
  end

end