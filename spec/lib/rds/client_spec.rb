require 'rspec'
require 'aws_helpers/rds'

describe AwsHelpers::RDS do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  describe '.new' do

    it "should call AwsHelpers::Common::Client's initialize method" do
      expect(AwsHelpers::RDS).to receive(:new).with(options).and_return(AwsHelpers::Config)
      AwsHelpers::RDS.new(options)
    end

    it 'should create an instance of Aws::RDS::Client' do
      expect(AwsHelpers::Config.new(options).aws_rds_client).to match(Aws::RDS::Client)
      AwsHelpers::RDS.new(options)
    end

    it 'should create an instance of Aws::IAM::Client' do
      expect(AwsHelpers::Config.new(options).aws_iam_client).to match(Aws::IAM::Client)
      AwsHelpers::RDS.new(options)
    end

  end

end
