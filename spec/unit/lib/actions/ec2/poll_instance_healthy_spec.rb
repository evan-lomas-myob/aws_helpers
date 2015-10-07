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

  let(:ready_output) { Base64.encode64('Windows is Ready to use') }
  let(:not_ready_output) { Base64.encode64('Windows Not Yet Ready') }

  let(:ready_console_output) { instance_double(Aws::EC2::Types::GetConsoleOutputResult, output: ready_output)}
  let(:not_ready_console_output) { instance_double(Aws::EC2::Types::GetConsoleOutputResult, output: not_ready_output)}

  let(:running_state) { instance_double(Aws::EC2::Types::InstanceState, name: is_running) }
  let(:pending_state) { instance_double(Aws::EC2::Types::InstanceState, name: is_pending) }

  let(:instance_running) { instance_double(Aws::EC2::Instance, state: running_state, platform: 'windows', console_output: ready_console_output) }
  let(:instance_pending) { instance_double(Aws::EC2::Instance, state: pending_state, platform: 'windows', console_output: ready_console_output) }

  let(:instance_not_ready) { instance_double(Aws::EC2::Instance, state: running_state, platform: 'windows', console_output: not_ready_console_output) }

  let(:stdout) { instance_double(IO) }
  let(:max_attempts) { 3 }
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

    it 'should wait until the console output contains Windows is Ready to use' do
      allow(stdout).to receive(:puts).with("Instance State is #{is_pending}.")
      allow(stdout).to receive(:puts).with("Instance State is #{is_running}.")
      expect(Aws::EC2::Instance).to receive(:new).and_return(instance_pending, instance_not_ready, instance_running)
      PollInstanceHealthy.new(instance_id, options).execute
    end


  end

end