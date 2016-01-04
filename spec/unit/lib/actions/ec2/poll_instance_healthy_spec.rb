require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers'
require 'aws_helpers/actions/ec2/poll_instance_healthy'

include AwsHelpers::Actions::EC2

describe PollInstanceHealthy do

  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }

  let(:running_state) { instance_double(Aws::EC2::Types::InstanceState, name: 'running') }
  let(:ok_state) { instance_double(Aws::EC2::Types::InstanceStatusSummary, status: 'ok') }
  let(:init_state) { instance_double(Aws::EC2::Types::InstanceStatusSummary, status: 'initializing') }

  let(:ok_status) { instance_double(Aws::EC2::Types::InstanceStatus, instance_id: instance_id, instance_state: running_state, instance_status: ok_state) }
  let(:init_status) { instance_double(Aws::EC2::Types::InstanceStatus, instance_id: instance_id, instance_state: running_state, instance_status: init_state) }

  let(:ok_response) { instance_double(Aws::EC2::Types::DescribeInstanceStatusResult, instance_statuses: [ok_status]) }
  let(:init_response) { instance_double(Aws::EC2::Types::DescribeInstanceStatusResult, instance_statuses: [init_status]) }

  let(:instance_id) { 'i-de42f500' }

  let(:stdout) { instance_double(IO) }
  let(:max_attempts) { 3 }
  let(:delay) { 0 }

  let(:options) { {stdout: stdout, delay: delay, max_attempts: max_attempts} }

  describe '#execute' do

    it 'should use the AwsHelpers::Utilities::Polling to poll until the image exists' do
      allow(stdout).to receive(:print).with("Instance State is running.\tInstance Status is initializing.\n")
      allow(stdout).to receive(:print).with("Instance State is running.\tInstance Status is ok.\n")
      expect(aws_ec2_client).to receive(:describe_instance_status).and_return(init_response, ok_response)
      PollInstanceHealthy.new(config, instance_id, options).execute
    end

    it 'should raise an exception is polling reaches max attempts' do
      allow(stdout).to receive(:print).with("Instance State is running.\tInstance Status is initializing.\n")
      allow(aws_ec2_client).to receive(:describe_instance_status).with(instance_ids: [instance_id]).and_return(init_response)
      expect { PollInstanceHealthy.new(config, instance_id, options).execute }.to raise_error("stopped waiting after #{max_attempts} attempts without success")
    end

  end

end