require 'aws_helpers/auto_scaling'
require 'aws_helpers/actions/auto_scaling/update_desired_capacity'
require 'aws_helpers/actions/elastic_load_balancing/check_healthy_instances'

include AwsHelpers
include AwsHelpers::Actions::AutoScaling
include AwsHelpers::Actions::ElasticLoadBalancing

describe UpdateDesiredCapacity do

  describe '#execute' do

    let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_auto_scaling_client: auto_scaling_client) }

    let(:auto_scaling_group_name) { 'name' }
    let(:auto_scaling_groups) { double(:auto_scaling_groups, load_balancer_names: ['load_balancer1']) }
    let(:check_healthy_instances) { instance_double(CheckHealthyInstances) }

    let(:desired_capacity) { 2 }
    let(:timeout) { 1 }

    subject { UpdateDesiredCapacity.new(config, auto_scaling_group_name, desired_capacity, timeout).execute }

    before(:each) do
      allow(auto_scaling_client).to receive(:set_desired_capacity).with(anything)
      allow(auto_scaling_client).to receive(:describe_auto_scaling_groups).with(anything).and_return(auto_scaling_groups)
      allow(CheckHealthyInstances).to receive(:new).with(anything, anything, anything).and_return(check_healthy_instances)
      allow(check_healthy_instances).to receive(:execute)
    end

    after(:each) do
      subject
    end

    it 'should call the execute method to update desired capacity' do
      expect(auto_scaling_client).to receive(:set_desired_capacity).with(auto_scaling_group_name: auto_scaling_group_name, desired_capacity: desired_capacity)
    end

    it 'should call the execute method to update desired capacity' do
      expect(auto_scaling_client).to receive(:describe_auto_scaling_groups).with(auto_scaling_group_name: auto_scaling_group_name).and_return(auto_scaling_groups)
    end


    it 'should call check healthy instances to confirm the number of instances' do
      expect(CheckHealthyInstances).to receive(:new).with(config, 'load_balancer1', desired_capacity).and_return(check_healthy_instances)
    end

    it 'should call check healthy instances to confirm the number of instances' do
      expect(check_healthy_instances).to receive(:execute)
    end

  end
end