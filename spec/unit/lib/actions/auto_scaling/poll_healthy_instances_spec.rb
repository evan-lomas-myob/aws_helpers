require 'aws-sdk-core'

require 'aws_helpers/config'
require 'aws_helpers/actions/auto_scaling/poll_healthy_instances'

include AwsHelpers
include Aws::AutoScaling::Types

describe PollHealthyInstances do

  let(:std_out) { instance_double(IO) }
  let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_auto_scaling_client: auto_scaling_client) }

  let(:auto_scaling_group_name) { 'name' }

  describe '#execute' do

    it 'should call the Aws::AutoScaling::Client #describe_auto_scaling_instances with correct parameters' do
      response = create_response(auto_scaling_group_name, Instance.new(lifecycle_state: 'InService'))
      expect(auto_scaling_client).to receive(:describe_auto_scaling_groups).with(auto_scaling_group_names: [auto_scaling_group_name]).and_return(response)
      allow(std_out).to receive(:puts)
      AwsHelpers::Actions::AutoScaling::PollHealthyInstances.new(std_out, config, auto_scaling_group_name, 1, 5).execute
    end

    it 'should output the instance status' do
      response = create_response(auto_scaling_group_name, Instance.new(lifecycle_state: 'InService'))
      allow(auto_scaling_client).to receive(:describe_auto_scaling_groups).and_return(response)
      expect(std_out).to receive(:puts).with("#{auto_scaling_group_name} instances. In Service:#{1}, Out of Service:#{0}")
      AwsHelpers::Actions::AutoScaling::PollHealthyInstances.new(std_out, config, auto_scaling_group_name, 1, 5).execute
    end

    it 'should poll until all instances are in service' do
      first_response = create_response(
          auto_scaling_group_name,
          Instance.new(lifecycle_state: 'InService'),
          Instance.new(lifecycle_state: 'Pending')
      )
      second_response = create_response(
          auto_scaling_group_name,
          Instance.new(lifecycle_state: 'InService'),
          Instance.new(lifecycle_state: 'InService')
      )
      allow(auto_scaling_client).to receive(:describe_auto_scaling_groups).and_return(first_response, second_response)
      expect(std_out).to receive(:puts).with("#{auto_scaling_group_name} instances. In Service:#{1}, Out of Service:#{1}")
      expect(std_out).to receive(:puts).with("#{auto_scaling_group_name} instances. In Service:#{2}, Out of Service:#{0}")
      AwsHelpers::Actions::AutoScaling::PollHealthyInstances.new(std_out, config, auto_scaling_group_name, 2, 5).execute
    end

    it 'should timeout if expected number of servers is not reached by the timeout period' do
      response = create_response(auto_scaling_group_name, Instance.new(lifecycle_state: 'Pending'))
      allow(auto_scaling_client).to receive(:describe_auto_scaling_groups).and_return(response)
      allow(std_out).to receive(:puts)
      expect{AwsHelpers::Actions::AutoScaling::PollHealthyInstances.new(std_out, config, auto_scaling_group_name, 1, 1).execute}.to raise_error(Timeout::Error)
    end

  end

  def create_response(auto_scaling_group_name, *instances)
    AutoScalingGroupsType.new(
        auto_scaling_groups: [
            AutoScalingGroup.new(
                auto_scaling_group_name: auto_scaling_group_name,
                instances: instances
            )
        ])
  end

end