require 'aws-sdk-core'

require 'aws_helpers/config'
require 'aws_helpers/actions/auto_scaling/retrieve_desired_capacity'

describe AwsHelpers::Actions::AutoScaling::RetrieveDesiredCapacity do

  describe '#execute' do

    let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_auto_scaling_client: auto_scaling_client) }

    let(:auto_scaling_group_name) { 'name' }
    let(:auto_scaling_group) { Aws::AutoScaling::Types::AutoScalingGroup.new(auto_scaling_group_name: auto_scaling_group_name, desired_capacity: desired_capacity) }
    let(:response) { Aws::AutoScaling::Types::AutoScalingGroupsType.new(auto_scaling_groups: [auto_scaling_group]) }

    let(:desired_capacity) { 3 }

    subject { AwsHelpers::Actions::AutoScaling::RetrieveDesiredCapacity.new(config, auto_scaling_group_name).execute }

    before(:each) do
      allow(auto_scaling_client).to receive(:describe_auto_scaling_groups).and_return(response)
    end

    it 'should call describe_auto_scaling_groups with correct parameters' do
      expect(auto_scaling_client).to receive(:describe_auto_scaling_groups).with(auto_scaling_group_names: [auto_scaling_group_name])
      subject
    end

    it 'should return the desired capacity' do
      expect(subject).to be(desired_capacity)
    end

  end

end