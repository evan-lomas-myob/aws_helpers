require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/elastic_load_balancing/poll_healthy_instances'

include AwsHelpers::Actions::ElasticLoadBalancing

describe 'PollHealthyInstances' do

  let(:aws_elastic_load_balancing_client) { instance_double(Aws::ElasticLoadBalancing::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_elastic_load_balancing_client: aws_elastic_load_balancing_client) }
  let(:stdout) { instance_double(IO) }
  let(:waiter) { instance_double(Aws::Waiters::Waiter, delay: 15, max_attempts: 40) }
  let(:load_balancer_name) { 'load_balancer' }
  let(:response) {
    double(:instance_states,
           instance_states:
               [
                   double(:instance_state, state: 'InService')
               ]
    )
  }

  describe '#execute' do

    before(:each) do
      allow(aws_elastic_load_balancing_client).to receive(:wait_until).and_yield(waiter)
      allow(waiter).to receive(:max_attempts=)
      allow(waiter).to receive(:before_wait).and_yield(1, response)
      allow(stdout).to receive(:puts)
    end

    it 'should call describe wait_until with correct parameters on the AWS::ElasticLoadBalancing::Client' do
      expect(aws_elastic_load_balancing_client).to receive(:wait_until).with(:instance_in_service, load_balancer_names: [load_balancer_name])
      PollHealthyInstances.new(stdout, config, load_balancer_name, 1, 60).execute
    end

    it 'should set the waiters max attempts to 4' do
      expect(waiter).to receive(:max_attempts=).with(4)
      PollHealthyInstances.new(stdout, config, load_balancer_name, 1, 60).execute
    end

    it 'log to stdout' do
      expect(stdout).to receive(:puts).with('In Service: 1 Out of Service: 0')
      PollHealthyInstances.new(stdout, config, load_balancer_name, 1, 60).execute
    end

  end
end