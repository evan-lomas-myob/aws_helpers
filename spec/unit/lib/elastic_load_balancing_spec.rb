require 'aws_helpers/elastic_load_balancing'

describe AwsHelpers::ElasticLoadBalancing do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { instance_double(AwsHelpers::Config) }

  describe '#initialize' do

    it 'should call AwsHelpers::Client initialize method' do
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::ElasticLoadBalancing.new(options)
    end

  end

  describe '#poll_healthy_instances' do

    let(:poll_healthy_instances) { double(PollInServiceInstances) }

    let(:load_balancer_name) { 'my_load_balancer' }
    let(:required_instances) { 1 }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(PollInServiceInstances).to receive(:new).and_return(poll_healthy_instances)
      allow(poll_healthy_instances).to receive(:execute)
    end

    subject { AwsHelpers::ElasticLoadBalancing.new(options).poll_in_service_instances(load_balancer_name) }

    it 'should create PollHealthyInstances with correct parameters' do
      expect(PollInServiceInstances).to receive(:new).with(config, [load_balancer_name], {})
      subject
    end

    it 'should call PollHealthyInstances #execute method' do
      expect(poll_healthy_instances).to receive(:execute)
      subject
    end

  end

end