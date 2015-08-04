require 'aws_helpers/auto_scaling'
require 'aws_helpers/actions/auto_scaling/update_desired_capacity'

include AwsHelpers
include AwsHelpers::Actions::AutoScaling

describe UpdateDesiredCapacity do

  describe '#execute' do

    let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }
    let(:load_balancing_client) { instance_double(Aws::ElasticLoadBalancing::Client) }

    # let(:load_balancers) { double(:auto_scaling_groups, load_balancer_names: ['load_balancer1']) }
    # let(:desired_instances) { double(:load_balancer_descriptions, instances: %w( 'instance_id1', 'instance_id2' ) ) }
    # let(:undesired_instances) { double(:load_balancer_descriptions, instances: %w( 'instance_id1' )) }

    let(:config) { instance_double(AwsHelpers::Config, aws_auto_scaling_client: auto_scaling_client, aws_elastic_load_balancing_client: load_balancing_client) }
    #
    let(:auto_scaling_group_name) { 'name' }
    # let(:auto_scaling_group_names) { [ 'name' ] }

    let(:desired_capacity) { 2 }
    let(:timeout) { 1 }

    it 'should call the aws auto_scaling_client to set desired capacity' do
      expect(auto_scaling_client).to receive(:set_desired_capacity).with(auto_scaling_group_name: auto_scaling_group_name, desired_capacity: desired_capacity)
      UpdateDesiredCapacity.new(config, auto_scaling_group_name, desired_capacity, timeout).execute
    end

    # it 'should raise an exception when the auto scaling groups load balancers are not at the desired capacity' do
    #   allow(auto_scaling_client).to receive(:set_desired_capacity).with(auto_scaling_group_name: auto_scaling_group_name, desired_capacity: desired_capacity)
    #   allow(auto_scaling_client).to receive(:describe_auto_scaling_groups).with(auto_scaling_group_name).and_return(load_balancers)
    #   allow(load_balancing_client).to receive(:describe_load_balancers).with(load_balancers.load_balancer_names).and_return(undesired_instances)
    #   expect(UpdateDesiredCapacity.new(config, auto_scaling_group_name, desired_capacity, timeout).execute).to raise_error('Not at capacity')
    # end

    # it 'should not raise en exception when the auto scaling groups load balancers are at the desired capacity' do
    #   allow(auto_scaling_client).to receive(:set_desired_capacity).with(auto_scaling_group_name: auto_scaling_group_name, desired_capacity: desired_capacity)
    #   allow(auto_scaling_client).to receive(:describe_auto_scaling_groups).with(auto_scaling_group_name).and_return(load_balancers)
    #   allow(load_balancing_client).to receive(:describe_load_balancers).with(load_balancers.load_balancer_names).and_return(desired_instances)
    #   expect(UpdateDesiredCapacity.new(config, auto_scaling_group_name, desired_capacity, timeout).execute).to_not raise_error
    # end

  end
end