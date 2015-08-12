require 'aws_helpers/auto_scaling'
require 'aws_helpers/actions/auto_scaling/update_desired_capacity'
require 'aws_helpers/actions/elastic_load_balancing/check_healthy_instances'

describe AwsHelpers::Actions::AutoScaling::UpdateDesiredCapacity do

  describe '#execute' do

    let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_auto_scaling_client: auto_scaling_client) }

    let(:auto_scaling_group_name) { 'name' }
    let(:auto_scaling_group) { Aws::AutoScaling::Types::AutoScalingGroup.new(load_balancer_names: ['load_balancer1'], instances: []) }
    let(:response) { Aws::AutoScaling::Types::AutoScalingGroupsType.new( auto_scaling_groups: [auto_scaling_group]) }

    let(:poll_in_service_instances) {instance_double(AwsHelpers::Actions::AutoScaling::PollInServiceInstances)}
    let(:check_healthy_instances) { instance_double(AwsHelpers::Actions::ElasticLoadBalancing::CheckHealthyInstances) }

    let(:desired_capacity) { 2 }
    let(:timeout) { 1 }

    subject { AwsHelpers::Actions::AutoScaling::UpdateDesiredCapacity.new(config, auto_scaling_group_name, desired_capacity, timeout).execute }

    before(:each) do
      allow(auto_scaling_client).to receive(:set_desired_capacity)
      allow(auto_scaling_client).to receive(:describe_auto_scaling_groups).and_return(response)
      allow(AwsHelpers::Actions::AutoScaling::PollInServiceInstances).to receive(:new).and_return(poll_in_service_instances)
      allow(poll_in_service_instances).to receive(:execute)
      allow(AwsHelpers::Actions::ElasticLoadBalancing::CheckHealthyInstances).to receive(:new).and_return(check_healthy_instances)
      allow(check_healthy_instances).to receive(:execute)
    end

    after(:each) do
      subject
    end

    it 'should set the desired capacity' do
      expect(auto_scaling_client).to receive(:set_desired_capacity).with(auto_scaling_group_name: auto_scaling_group_name, desired_capacity: desired_capacity)
    end

    it 'should retrieve the auto scaling groups description' do
      expect(auto_scaling_client).to receive(:describe_auto_scaling_groups).with(auto_scaling_group_names: [auto_scaling_group_name]).and_return(response)
    end

    it 'should call PollHealthyInstances with correct parameters' do
      expect(AwsHelpers::Actions::AutoScaling::PollInServiceInstances).to receive(:new).with(anything, config, auto_scaling_group_name)
    end

    it 'should call the execute method on PollInServiceInstances' do
      expect(poll_in_service_instances).to receive(:execute)
    end

    it 'should call check healthy instances for the given load balancer name' do
      expect(AwsHelpers::Actions::ElasticLoadBalancing::CheckHealthyInstances).to receive(:new).with(config, 'load_balancer1', desired_capacity).and_return(check_healthy_instances)
    end

    it 'should call the execute method to CheckHealthyInstances' do
      expect(check_healthy_instances).to receive(:execute)
    end

  end
end