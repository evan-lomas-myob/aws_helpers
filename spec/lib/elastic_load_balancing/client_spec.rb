require 'rspec'
require 'aws_helpers/elastic_load_balancing/client'
require 'aws_helpers/elastic_load_balancing/poll_healthy_instances'

describe AwsHelpers::ElasticLoadBalancing::Client do

  describe '.new' do

    context 'without options' do

      it "should call AwsHelpers::Common::Client's initialize method" do
        expect(AwsHelpers::Common::Client).to receive(:new)
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

  describe '#poll_healthy_instances' do

    let(:elastic_load_balancing_client) { double(Aws::ElasticLoadBalancing::Client) }
    let(:pool_healthy_instances) { double(AwsHelpers::ElasticLoadBalancing::PollHealthyInstances) }

    before(:each) do
      allow(AwsHelpers::ElasticLoadBalancing::PollHealthyInstances).to receive(:new).with(anything, anything, anything, anything).and_return(pool_healthy_instances)
      allow(pool_healthy_instances).to receive(:execute)
    end

    context 'with default configuration' do

      before(:each) do
        allow(Aws::ElasticLoadBalancing::Client).to receive(:new).and_return(elastic_load_balancing_client)
      end

      context 'without options' do

        after(:each) do
          AwsHelpers::ElasticLoadBalancing::Client.new.poll_healthy_instances('name', 1, 1)
        end

        it 'should create Aws::ElasticLoadBalancer::Client' do
          expect(Aws::ElasticLoadBalancing::Client).to receive(:new).and_return(elastic_load_balancing_client)
        end

        it 'should create an instance of PollHealthInstances' do
          expect(AwsHelpers::ElasticLoadBalancing::PollHealthyInstances).to receive(:new).with(elastic_load_balancing_client, 'name', 1, 1)
        end

        it 'should call execute on PollHealthInstances' do
          expect(pool_healthy_instances).to receive(:execute)
        end

      end

      context 'with options' do

        let(:options) { {endpoint: 'http://endpoint'} }

        after(:each) do
          AwsHelpers::ElasticLoadBalancing::Client.new(options).poll_healthy_instances('name', 1, 1)
        end

        it 'should create Aws::ElasticLoadBalancer::Client passing the correct options' do
          expect(Aws::ElasticLoadBalancing::Client).to receive(:new).with(hash_including(options)).and_return(elastic_load_balancing_client)
        end

      end

    end

    context 'with custom configuration' do

      after(:each) do
        elb_client = AwsHelpers::ElasticLoadBalancing::Client.new
        elb_client.configure { |config|
          config.aws_elastic_load_balancing_client = elastic_load_balancing_client
        }
        elb_client.poll_healthy_instances('name', 1, 1)
      end

      it 'should create an instance of PollHealthInstances with the custom elastic_load_balancing_client' do
        expect(AwsHelpers::ElasticLoadBalancing::PollHealthyInstances).to receive(:new).with(elastic_load_balancing_client, anything, anything, anything)
      end

    end

  end

end