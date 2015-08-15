require 'aws_helpers/config'
require 'aws_helpers/actions/auto_scaling/poll_load_balancers_in_service_instances'

describe AwsHelpers::Actions::AutoScaling::PollLoadBalancersInServiceInstances do

  describe '#execute' do

    let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_auto_scaling_client: auto_scaling_client) }
    let(:poll_in_service_instances) { instance_double(AwsHelpers::Actions::ElasticLoadBalancing::PollInServiceInstances) }

    let(:auto_scaling_group_name) { 'auto_scaling_group_name' }
    let(:load_balancer_name_first) { 'load_balancer_name_first' }
    let(:load_balancer_name_second) { 'load_balancer_name_second' }

    let(:response) { Aws::AutoScaling::Types::DescribeLoadBalancersResponse.new(
        load_balancers: [
            Aws::AutoScaling::Types::LoadBalancerState.new(load_balancer_name: load_balancer_name_first),
            Aws::AutoScaling::Types::LoadBalancerState.new(load_balancer_name: load_balancer_name_second)
        ]) }

    before(:each) do
      allow(auto_scaling_client).to receive(:describe_load_balancers).and_return(response)
      allow(AwsHelpers::Actions::ElasticLoadBalancing::PollInServiceInstances).to receive(:new).and_return(poll_in_service_instances)
      allow(poll_in_service_instances).to receive(:execute)
    end

    after(:each) do
      AwsHelpers::Actions::AutoScaling::PollLoadBalancersInServiceInstances.new(config, auto_scaling_group_name).execute
    end

    it 'should call Aws::AutoScaling::Client #describe_load_balancers with correct parameters' do
      expect(auto_scaling_client).to receive(:describe_load_balancers).with(auto_scaling_group_name: auto_scaling_group_name)
    end

    it 'should call PollInServiceInstances #new with correct parameters' do
      expect(AwsHelpers::Actions::ElasticLoadBalancing::PollInServiceInstances).to receive(:new).with(config, [load_balancer_name_first, load_balancer_name_second], {})
    end

    it 'should call PollInServiceInstances #execute method' do
      expect(poll_in_service_instances).to receive(:execute)
    end

  end
end