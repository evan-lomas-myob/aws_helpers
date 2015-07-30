require 'rspec'
require 'aws_helpers/ec2/client'

describe AwsHelpers::EC2::Client do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  context '.new' do

    it "should call AwsHelpers::Common::Client's initialize method" do
      expect(AwsHelpers::EC2::Client).to receive(:new).with(options).and_return(AwsHelpers::EC2::Config)
      AwsHelpers::EC2::Client.new(options)
    end

  end

  it 'should create an instance of Aws::EC2::Client' do
    expect(AwsHelpers::EC2::Config.new(options).aws_ec2_client).to match(Aws::EC2::Client)
    AwsHelpers::EC2::Client.new(options)
  end

end
