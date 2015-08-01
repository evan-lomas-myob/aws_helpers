require 'aws_helpers/auto_scaling'

describe AwsHelpers::AutoScaling do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  context '.new' do

    it "should call AwsHelpers::Common::Client's initialize method" do
      expect(AwsHelpers::AutoScaling).to receive(:new).with(options).and_return(AwsHelpers::Config)
      AwsHelpers::AutoScaling.new(options)
    end

  end

  context 'AutoScaling Config methods' do

    it 'should create an instance of Aws::AutoScaling::Client' do
      expect(AwsHelpers::Config.new(options).aws_auto_scaling_client).to match(Aws::AutoScaling::Client)
      AwsHelpers::AutoScaling.new(options)
    end

    it 'should create an instance of Aws::ElasticLoadBalancing::Client' do
      expect(AwsHelpers::Config.new(options).aws_elastic_load_balancing_client).to match(Aws::ElasticLoadBalancing::Client)
      AwsHelpers::AutoScaling.new(options)
    end

  end

end