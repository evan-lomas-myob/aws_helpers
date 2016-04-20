require 'aws_helpers/elastic_load_balancing'

describe AwsHelpers::ElasticLoadBalancing do
  let(:load_balancer_name) { 'Batman' }
  let(:request) { PollInServiceInstancesRequest.new(load_balancer_name: load_balancer_name) }
  let(:director) { instance_double(PollInServiceInstancesDirector) }
  let(:elb_client) { instance_double(Aws::ElasticLoadBalancing::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_elastic_load_balancing_client: elb_client) }

  before do
    allow(AwsHelpers::Config).to receive(:new).and_return(config)
    allow(PollInServiceInstancesRequest).to receive(:new).and_return(request)
    allow(PollInServiceInstancesDirector).to receive(:new).and_return(director)
    allow(director).to receive(:execute)
  end

  describe '#initialize' do
    it 'should call AwsHelpers::Client initialize method' do
      options = { endpoint: 'http://endpoint' }
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::ElasticLoadBalancing.new(options)
    end
  end

  describe '#poll_healthy_instances' do
    it 'should create a PollInServiceInstancesRequest' do
      expect(PollInServiceInstancesRequest)
        .to receive(:new)
        .with(load_balancer_name: load_balancer_name)
      AwsHelpers::ElasticLoadBalancing.new.poll_in_service_instances(load_balancer_name)
    end

    it 'should create a PollInServiceInstancesDirector' do
      expect(PollInServiceInstancesDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::ElasticLoadBalancing.new.poll_in_service_instances(load_balancer_name)
    end

    it 'should call execute on the director' do
      expect(director)
        .to receive(:execute)
        .with(request)
      AwsHelpers::ElasticLoadBalancing.new.poll_in_service_instances(load_balancer_name)
    end
  end
end
