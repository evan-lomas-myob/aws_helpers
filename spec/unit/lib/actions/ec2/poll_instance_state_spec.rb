require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers'
require 'aws_helpers/actions/ec2/poll_instance_state'

include AwsHelpers::Actions::EC2

describe PollInstanceState do

  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }

  let(:instance_id) { 'i-de42f500' }

  let(:is_running) { 'running' }
  let(:is_stopped) { 'stopped' }
  let(:is_stopping) { 'stopping' }

  let(:running_state) { instance_double(Aws::EC2::Types::InstanceState, name: is_running) }
  let(:stopped_state) { instance_double(Aws::EC2::Types::InstanceState, name: is_stopped) }
  let(:stopping_state) { instance_double(Aws::EC2::Types::InstanceState, name: is_stopping) }

  let(:instance_running) { instance_double(Aws::EC2::Instance, state: running_state) }
  let(:instance_stopped) { instance_double(Aws::EC2::Instance, state: stopped_state) }
  let(:instance_stopping) { instance_double(Aws::EC2::Instance, state: stopping_state) }

  let(:stdout) { instance_double(IO) }
  let(:max_attempts) { 3 }
  let(:delay) { 0 }

  let(:options) { {stdout: stdout, delay: delay, max_attempts: max_attempts} }

  describe '#execute' do

    it 'should use the AwsHelpers::Utilities::Polling to poll until the image is stopping' do
      allow(stdout).to receive(:puts).with("Instance State is #{is_running}.")
      allow(stdout).to receive(:puts).with("Instance State is #{is_stopping}.")
      expect(Aws::EC2::Instance).to receive(:new).and_return(instance_running, instance_running, instance_stopping)
      PollInstanceState.new(instance_id, is_stopping, options).execute
    end

    it 'should raise an exception is polling reaches max attempts' do
      allow(stdout).to receive(:puts).with("Instance State is #{is_running}.")
      allow(Aws::EC2::Instance).to receive(:new).and_return(instance_running)
      expect { PollInstanceState.new(instance_id, is_stopping, options).execute }.to raise_error("stopped waiting after #{max_attempts} attempts without success")
    end

  end

end