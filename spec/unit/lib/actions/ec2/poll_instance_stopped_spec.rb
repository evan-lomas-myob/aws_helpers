require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers'
require 'aws_helpers/actions/ec2/poll_instance_stopped'

include AwsHelpers::Actions::EC2

describe PollInstanceStopped do

  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }

  let(:instance_id) { 'i-de42f500' }

  let(:is_stopped) { 'stopped' }
  let(:is_shutting_down) { 'shutting-down' }

  let(:stopped_state) { instance_double(Aws::EC2::Types::InstanceState, name: is_stopped) }
  let(:shutting_down_state) { instance_double(Aws::EC2::Types::InstanceState, name: is_shutting_down) }

  let(:instance_stopped) { instance_double(Aws::EC2::Instance, state: stopped_state) }
  let(:instance_shutting_down) { instance_double(Aws::EC2::Instance, state: shutting_down_state) }

  let(:stdout) { instance_double(IO) }
  let(:max_attempts) { 2 }
  let(:delay) { 0 }

  let(:options) { {stdout: stdout, delay: delay, max_attempts: max_attempts} }

  describe '#execute' do

    it 'should use the AwsHelpers::Utilities::Polling to poll until the image exists' do
      allow(stdout).to receive(:puts).with("Instance State is #{is_stopped}.")
      allow(stdout).to receive(:puts).with("Instance State is #{is_shutting_down}.")
      expect(Aws::EC2::Instance).to receive(:new).and_return(instance_shutting_down, instance_stopped)
      PollInstanceStopped.new(instance_id, options).execute
    end

    it 'should raise an exception is polling reaches max attempts' do
      allow(stdout).to receive(:puts).with("Instance State is #{is_shutting_down}.")
      allow(Aws::EC2::Instance).to receive(:new).and_return(instance_shutting_down)
      expect { PollInstanceStopped.new(instance_id, options).execute }.to raise_error("stopped waiting after #{max_attempts} attempts without success")
    end

  end

end