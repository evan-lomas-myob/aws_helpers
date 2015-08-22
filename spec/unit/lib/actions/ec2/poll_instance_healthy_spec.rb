require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers'
require 'aws_helpers/actions/ec2/poll_instance_healthy'

include AwsHelpers::Actions::EC2

describe PollInstanceHealthy do

  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }

  let(:instance_id) { 'i-de42f500' }

  let(:is_running) { 'running' }
  let(:is_pending) { 'pending' }

  let(:running_state) { instance_double(Aws::EC2::Types::InstanceState, name: is_running) }
  let(:pending_state) { instance_double(Aws::EC2::Types::InstanceState, name: is_pending) }

  let(:instance_running) { instance_double(Aws::EC2::Instance, state: running_state) }
  let(:instance_pending) { instance_double(Aws::EC2::Instance, state: pending_state) }

  let(:stdout) { instance_double(IO) }
  let(:max_attempts) { 2 }
  let(:delay) { 0 }

  let(:options) { {stdout: stdout, delay: delay, max_attempts: max_attempts} }

  describe '#execute' do

    it 'should use the AwsHelpers::Utilities::Polling to poll until the image exists' do
      allow(stdout).to receive(:puts).with("Instance State is #{is_pending}.")
      allow(stdout).to receive(:puts).with("Instance State is #{is_running}.")
      expect(Aws::EC2::Instance).to receive(:new).and_return(instance_pending, instance_running)
      PollInstanceHealthy.new(instance_id, options).execute
    end

    it 'should raise an exception is polling reaches max attempts' do
      allow(stdout).to receive(:puts).with("Instance State is #{is_pending}.")
      allow(Aws::EC2::Instance).to receive(:new).and_return(instance_pending)
      expect { PollInstanceHealthy.new(instance_id, options).execute }.to raise_error("stopped waiting after #{max_attempts} attempts without success")
    end

  end

end