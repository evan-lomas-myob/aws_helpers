require 'rspec'
require 'aws_helpers/ec2/client'
require 'aws_helpers/ec2/image_create'

describe AwsHelpers::EC2::Client do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  describe '.new' do

    it "should call AwsHelpers::Common::Client's initialize method" do
      expect(AwsHelpers::EC2::Client).to receive(:new).with(options).and_return(AwsHelpers::EC2::Config)
      AwsHelpers::EC2::Client.new(options)
    end

  end

end
