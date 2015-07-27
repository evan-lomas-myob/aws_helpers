require 'rspec'
require 'aws_helpers/elastic_load_balancing/client'
require 'aws_helpers/elastic_load_balancing/poll_healthy_instances'

describe AwsHelpers::ElasticLoadBalancing::Client do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  describe '.new' do

    it "should call AwsHelpers::Common::Client's initialize method" do
      expect(AwsHelpers::Common::Client).to receive(:new).with(options)
      AwsHelpers::ElasticLoadBalancing::Client.new(options)
    end

  end

  describe '#poll_healthy_instances' do

    let(:elastic_load_balancing_client) { double(Aws::ElasticLoadBalancing::Client) }
    let(:load_balancer_name) { 'my_load_balancer' }
    let(:required_instances) { 1 }
    let(:timeout) { 1 }

    it 'should pass options to the Aws::ElasticLoadBalancer::Client' do
      expect(Aws::ElasticLoadBalancing::Client).to receive(:new).with(hash_including(options)).and_return(elastic_load_balancing_client)
      AwsHelpers::ElasticLoadBalancing::Client.new(options).poll_healthy_instances(load_balancer_name, required_instances, timeout)
    end

    it 'should be able to call PollHealthInstances execute method with 4 parameters' do
      allow(AwsHelpers::ElasticLoadBalancing::PollHealthyInstances).to receive(:new).with(anything, load_balancer_name, required_instances, timeout).and_return(elastic_load_balancing_client)
      expect(elastic_load_balancing_client).to receive(:execute)
      AwsHelpers::ElasticLoadBalancing::Client.new(options).poll_healthy_instances(load_balancer_name, required_instances, timeout)
    end

  end

end