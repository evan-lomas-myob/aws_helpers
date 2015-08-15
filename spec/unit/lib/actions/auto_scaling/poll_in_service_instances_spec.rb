require 'aws-sdk-core'

require 'aws_helpers/config'
require 'aws_helpers/actions/auto_scaling/poll_in_service_instances'

describe AwsHelpers::Actions::AutoScaling::PollInServiceInstances do

  let(:stdout) { instance_double(IO) }
  let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_auto_scaling_client: auto_scaling_client) }
  let(:auto_scaling_group_name) { 'name' }

  before(:each) {
    allow(stdout).to receive(:puts)
  }

  describe '#execute' do

    it 'should call the Aws::AutoScaling::Client #describe_auto_scaling_instances with correct parameters' do
      response = create_response(auto_scaling_group_name, 'InService')
      expect(auto_scaling_client).to receive(:describe_auto_scaling_groups).with(auto_scaling_group_names: [auto_scaling_group_name]).and_return(response)
      poll_in_service_instances(config, auto_scaling_group_name, stdout: stdout, max_attempts:1, delay:0)
    end

    it 'should output the desired capacity' do
      response = create_response(auto_scaling_group_name)
      allow(auto_scaling_client).to receive(:describe_auto_scaling_groups).and_return(response)
      expect(stdout).to receive(:puts).with("Auto Scaling Group=#{auto_scaling_group_name}. Desired Capacity=0")
      poll_in_service_instances(config, auto_scaling_group_name, stdout: stdout, max_attempts:1, delay:0)
    end


    it 'should output the instance status' do
      response = create_response(auto_scaling_group_name, 'InService')
      allow(auto_scaling_client).to receive(:describe_auto_scaling_groups).and_return(response)
      expect(stdout).to receive(:puts).with("Auto Scaling Group=#{auto_scaling_group_name}. Desired Capacity=1, InService=1")
      poll_in_service_instances(config, auto_scaling_group_name, stdout: stdout, max_attempts:1, delay:0)
    end

    it 'should poll until all instances are in service' do
      first_response = create_response(auto_scaling_group_name, 'InService', 'Pending')
      second_response = create_response(auto_scaling_group_name, 'InService', 'InService')
      allow(auto_scaling_client).to receive(:describe_auto_scaling_groups).and_return(first_response, second_response)
      allow(stdout).to receive(:puts).with("Auto Scaling Group=#{auto_scaling_group_name}. Desired Capacity=2, InService=1, Pending=1")
      expect(stdout).to receive(:puts).with("Auto Scaling Group=#{auto_scaling_group_name}. Desired Capacity=2, InService=2")
      poll_in_service_instances(config, auto_scaling_group_name, stdout: stdout, max_attempts:2, delay:0)
    end

    it 'should throw an error if expected number of servers is not reached by the retry period' do
      response = create_response(auto_scaling_group_name, 'Pending')
      allow(auto_scaling_client).to receive(:describe_auto_scaling_groups).and_return(response)
      expect { poll_in_service_instances(config, auto_scaling_group_name, stdout: stdout, max_attempts:1, delay:0) }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
    end

  end

  def poll_in_service_instances(config, auto_scaling_group_name, options)
    AwsHelpers::Actions::AutoScaling::PollInServiceInstances.new(config, auto_scaling_group_name, options).execute
  end

  def create_response(auto_scaling_group_name, *lifecycle_states)
    Aws::AutoScaling::Types::AutoScalingGroupsType.new(
      auto_scaling_groups: [
        Aws::AutoScaling::Types::AutoScalingGroup.new(
          desired_capacity: lifecycle_states.size,
          auto_scaling_group_name: auto_scaling_group_name,
          instances: lifecycle_states.map { |lifecycle_state| Aws::AutoScaling::Types::Instance.new(lifecycle_state: lifecycle_state) }
        )
      ])
  end

end