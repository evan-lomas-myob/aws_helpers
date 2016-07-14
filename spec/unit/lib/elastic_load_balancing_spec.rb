require 'aws_helpers/elastic_load_balancing'

describe AwsHelpers::ElasticLoadBalancing do
  let(:config) { instance_double(AwsHelpers::Config) }

  describe '#initialize' do
    it 'should call AwsHelpers::Client initialize method' do
      options = { endpoint: 'http://endpoint' }
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::ElasticLoadBalancing.new(options)
    end
  end

  describe '#poll_healthy_instances' do
    let(:poll_healthy_instances) { instance_double(PollInServiceInstances) }
    let(:load_balancer_name) { 'my_load_balancer' }
    let(:required_instances) { 1 }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(PollInServiceInstances).to receive(:new).and_return(poll_healthy_instances)
      allow(poll_healthy_instances).to receive(:execute)
    end

    subject { AwsHelpers::ElasticLoadBalancing.new.poll_in_service_instances(load_balancer_name) }

    it 'should create PollHealthyInstances with correct parameters' do
      expect(PollInServiceInstances).to receive(:new).with(config, [load_balancer_name], {})
      subject
    end

    it 'should call PollHealthyInstances #execute method' do
      expect(poll_healthy_instances).to receive(:execute)
      subject
    end
  end

  describe '#create_tag' do
    let(:create_tag) { instance_double(CreateTag) }
    let(:load_balancer_name) { 'my_load_balancer' }
    let(:tag_key) { "green-asg" }
    let(:tag_value) { "hulk" }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(CreateTag).to receive(:new).and_return(create_tag)
      allow(create_tag).to receive(:execute)
    end

    subject { AwsHelpers::ElasticLoadBalancing.new.create_tag(load_balancer_name, tag_key, tag_value) }

    it 'should create CreateTag with correct parameters' do
      expect(CreateTag).to receive(:new).with(config, load_balancer_name, tag_key, tag_value, {})
      subject
    end

    it 'should call CreateTag #execute method' do
      expect(create_tag).to receive(:execute)
      subject
    end
  end
end
