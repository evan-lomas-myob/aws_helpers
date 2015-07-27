require 'rspec'
require 'aws_helpers/rds/client'
require 'aws_helpers/rds/snapshot'

describe AwsHelpers::RDS::Client do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  describe '.new' do

    it "should call AwsHelpers::Common::Client's initialize method" do
      expect(AwsHelpers::Common::Client).to receive(:new).with(options)
      AwsHelpers::RDS::Client.new(options)
    end

  end

  let(:rds_client) { double(Aws::RDS::Client) }
  let(:iam_client) { double(Aws::IAM::Client) }

  describe '#snapshot_create' do
    it 'should pass options to the Aws::RDS::Client' do
      expect(Aws::RDS::Client).to receive(:new).with(hash_including(options)).and_return(rds_client)
      AwsHelpers::RDS::Client.new(options).snapshot_create(anything, false)
    end

    it 'should call Aws::RDS::Client create method and receive an Aws::RDS::Client' do
      allow(rds_client).to receive(:snapshot_create)
      expect(AwsHelpers::RDS::Snapshot).to receive(:new).with(be_an_instance_of(Aws::RDS::Client), be_an_instance_of(Aws::IAM::Client), anything, anything).and_return(rds_client)
      AwsHelpers::RDS::Client.new(options).snapshot_create(anything, false)
    end

  end

=begin
  describe '#snapshots_delete' do
    #(db_instance_id, options = nil)
  end
  describe '#snapshot_latest' do
    #(db_instance_id)
  end
=end

end