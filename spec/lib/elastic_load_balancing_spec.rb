require 'aws_helpers/elastic_load_balancing'

describe AwsHelpers::ElasticLoadBalancing do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(AwsHelpers::Config) }

  describe '#initialize' do

    it 'should call AwsHelpers::Client initialize method' do
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::ElasticLoadBalancing.new(options)
    end

  end

  describe '#poll_healthy_instances' do

    let(:poll_healthy_instances) { double(PollHealthyInstances) }

    let(:load_balancer_name) { 'my_load_balancer' }
    let(:required_instances) { 1 }
    let(:timeout) { 1 }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(PollHealthyInstances).to receive(:new).with(anything, anything, anything, anything).and_return(poll_healthy_instances)
      allow(poll_healthy_instances).to receive(:execute)
    end

    subject { AwsHelpers::ElasticLoadBalancing.new(options).poll_healthy_instances(load_balancer_name: load_balancer_name, required_instances: required_instances, timeout: timeout) }

    it 'should create PollHealthyInstances' do
      expect(PollHealthyInstances).to receive(:new).with(config, load_balancer_name, required_instances, timeout)
      subject
    end

    it 'should call PollHealthyInstances execute method' do
      expect(poll_healthy_instances).to receive(:execute)
      subject
    end

  end

end