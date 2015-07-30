require 'rspec'
require 'aws_helpers/elastic_load_balancing/client'
require 'aws_helpers/elastic_load_balancing/poll_healthy_instances'

describe AwsHelpers::ElasticLoadBalancing::Client do

  describe '.new' do

    context 'without options' do

      it "should call AwsHelpers::Common::Client's initialize method" do
        expect(AwsHelpers::ElasticLoadBalancing::Client).to receive(:new).and_return(AwsHelpers::ElasticLoadBalancing::Config)
        AwsHelpers::ElasticLoadBalancing::Client.new
      end

    end

    context 'with options' do

      let(:options) { {endpoint: 'http://endpoint'} }

      it "should call AwsHelpers::Common::Client's initialize method with the correct options" do
        expect(AwsHelpers::Common::Client).to receive(:new).with(options)
        AwsHelpers::ElasticLoadBalancing::Client.new(options)
      end

    end
  end

end