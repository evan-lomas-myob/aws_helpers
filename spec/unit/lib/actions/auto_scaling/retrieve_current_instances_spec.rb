require 'aws-sdk-core'

require 'aws_helpers/config'
require 'aws_helpers/actions/auto_scaling/retrieve_current_instances'

describe AwsHelpers::Actions::AutoScaling::RetrieveCurrentInstances do
  describe '#execute' do
    let(:ec2_client) { instance_double(Aws::EC2::Client) }
    let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }

    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client, aws_auto_scaling_client: auto_scaling_client) }

    let(:instance_id) { 'i-12345678' }
    let(:instances) { [instance_double(Aws::EC2::Types::Instance, instance_id: instance_id)] }
    let(:reservation) { instance_double(Aws::EC2::Types::Reservation, instances: instances) }

    let(:auto_scaling_group_name) { 'auto_scaling_group_name' }
    let(:auto_scaling_group) { Aws::AutoScaling::Types::AutoScalingGroup.new(auto_scaling_group_name: auto_scaling_group_name, instances: instances) }

    let(:describe_instance_response) { Aws::EC2::Types::DescribeInstancesResult.new(reservations: [reservation]) }
    let(:auto_scaling_group_types_response) { Aws::AutoScaling::Types::AutoScalingGroupsType.new(auto_scaling_groups: [auto_scaling_group]) }

    let(:empty_auto_scaling_group_types_response) { Aws::AutoScaling::Types::AutoScalingGroupsType.new(auto_scaling_groups: nil) }

    subject { AwsHelpers::Actions::AutoScaling::RetrieveCurrentInstances.new(config, auto_scaling_group_name).execute }

    before(:each) do
      allow(ec2_client).to receive(:describe_instances).and_return(describe_instance_response)
      allow(auto_scaling_client).to receive(:describe_auto_scaling_groups).and_return(auto_scaling_group_types_response)
    end

    it 'should call describe_auto_scaling_groups with correct parameters' do
      expect(auto_scaling_client).to receive(:describe_auto_scaling_groups).with(auto_scaling_group_names: [auto_scaling_group_name])
      subject
    end

    it 'should retrieve the instances for the auto scaling group' do
      expect(ec2_client).to receive(:describe_instances).with(instance_ids: [instance_id])
      subject
    end

    it 'should return an empty array if response is nil' do
      allow(auto_scaling_client).to receive(:describe_auto_scaling_groups).and_return([empty_auto_scaling_group_types_response])
      expect(subject).to eq([])
    end


  end
end
