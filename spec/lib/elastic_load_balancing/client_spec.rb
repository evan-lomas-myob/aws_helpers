require 'rspec'
require 'aws_helpers/elastic_load_balancing'

describe AwsHelpers::ElasticLoadBalancing do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  context '.new' do

    context 'without options' do

      it "should call AwsHelpers::Common::Client's initialize method" do
        expect(AwsHelpers::ElasticLoadBalancing).to receive(:new).and_return(AwsHelpers::Config)
        AwsHelpers::ElasticLoadBalancing.new(options)
      end

    end

    context 'with options' do

      it "should call AwsHelpers::Common::Client's initialize method with the correct options" do
        expect(AwsHelpers::Client).to receive(:new).with(options)
        AwsHelpers::ElasticLoadBalancing.new(options)
      end

    end

  end

  it 'should create an instance of Aws::ElasticLoadBalancing::Client' do
    expect(AwsHelpers::Config.new(options).aws_elastic_load_balancing_client).to match(Aws::ElasticLoadBalancing::Client)
  end

end