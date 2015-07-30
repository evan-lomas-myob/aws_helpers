require 'rspec'
require 'aws_helpers/elastic_load_balancing/client'
require 'aws_helpers/elastic_load_balancing/poll_healthy_instances'

describe 'AwsHelpers::ElasticLoadBalancing::PollHealthyInstances' do

  let(:load_balancer_name) { 'my_loadbalancer' }
  let(:required_instances) { 2 }
  let(:timeout) { 5 }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_elastic_load_balancing_client: double) }
  let(:poll_healthy_instances) { double(AwsHelpers::ElasticLoadBalancing::PollHealthyInstances) }

  it '#poll_healthy_instances' do

    allow(AwsHelpers::ElasticLoadBalancing::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::ElasticLoadBalancing::PollHealthyInstances).to receive(:new).with(config, load_balancer_name, required_instances, timeout).and_return(poll_healthy_instances)
    expect(poll_healthy_instances).to receive(:execute)
    AwsHelpers::ElasticLoadBalancing::Client.new(options).poll_healthy_instances(load_balancer_name, required_instances, timeout)

  end

end