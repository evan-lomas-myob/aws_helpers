require 'rspec'
require 'aws_helpers/rds/client'

describe 'AwsHelpers::RDS::Client' do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  describe '.new' do

    it "should call AwsHelpers::Common::Client's initialize method" do
      expect(AwsHelpers::RDS::Client).to receive(:new).with(options).and_return(AwsHelpers::RDS::Config)
      AwsHelpers::RDS::Client.new(options)
    end

    it 'should create an instance of Aws::RDS::Client' do
      expect(AwsHelpers::RDS::Config.new(options).aws_rds_client).to match(Aws::RDS::Client)
      AwsHelpers::RDS::Client.new(options)
    end

    it 'should create an instance of Aws::IAM::Client' do
      expect(AwsHelpers::RDS::Config.new(options).aws_iam_client).to match(Aws::IAM::Client)
      AwsHelpers::RDS::Client.new(options)
    end

  end

end
