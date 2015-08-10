require 'aws_helpers/auto_scaling'
require 'aws_helpers/actions/auto_scaling/update_desired_capacity'
require 'aws_helpers/actions/elastic_load_balancing/check_healthy_instances'

include AwsHelpers
include AwsHelpers::Actions::AutoScaling
include AwsHelpers::Actions::ElasticLoadBalancing
include Aws::AutoScaling::Types

describe UpdateDesiredCapacity do

  describe '#execute' do

    let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_auto_scaling_client: auto_scaling_client) }

    let(:auto_scaling_group_name) { 'name' }
    let(:auto_scaling_group) { instance_double(AutoScalingGroup, load_balancer_names: ['load_balancer1']) }
    let(:response) { instance_double(AutoScalingGroupsType, auto_scaling_groups: [auto_scaling_group]) }

    let(:check_healthy_instances) { instance_double(CheckHealthyInstances) }

    let(:desired_capacity) { 2 }
    let(:timeout) { 1 }

    subject { UpdateDesiredCapacity.new(config, auto_scaling_group_name, desired_capacity, timeout).execute }

    before(:each) do
      allow(auto_scaling_client).to receive(:set_desired_capacity)
      allow(auto_scaling_client).to receive(:describe_auto_scaling_groups).and_return(response)
      allow(CheckHealthyInstances).to receive(:new).and_return(check_healthy_instances)
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

    it 'should call check healthy instances for the given load balancer name' do
      expect(CheckHealthyInstances).to receive(:new).with(config, 'load_balancer1', desired_capacity).and_return(check_healthy_instances)
    end

    it 'should call the execute method to check healthy instances' do
      expect(check_healthy_instances).to receive(:execute)
    end

  end
end