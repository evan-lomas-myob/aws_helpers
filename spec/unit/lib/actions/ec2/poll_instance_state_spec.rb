require 'aws-sdk-core'
require 'aws_helpers'
require 'aws_helpers/actions/ec2/poll_instance_state'

include AwsHelpers::Actions::EC2

describe PollInstanceState do

  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }

  let(:instance_id) { 'i-de42f500' }
  let(:is_running) { 'running' }
  let(:is_stopped) { 'stopped' }

  let(:stdout) { instance_double(IO) }
  let(:max_attempts) { 2 }
  let(:options) { { stdout: stdout, delay: 0, max_attempts: max_attempts } }

  describe '#execute' do

    before(:each){
      allow(stdout).to receive(:puts)
    }

    it 'should use the AwsHelpers::Utilities::Polling to poll until the image is in the expect state' do
      expect(aws_ec2_client).to receive(:describe_instance_status).with(instance_ids: [instance_id]).and_return(
        create_status_result(is_running), create_status_result(is_stopped)
      )
      PollInstanceState.new(config, instance_id, is_stopped, options).execute
    end

    it 'should raise an exception is polling reaches max attempts' do
      allow(aws_ec2_client).to receive(:describe_instance_status).and_return(create_status_result(is_running))
      expect { PollInstanceState.new(config, instance_id, is_stopped, options).execute }.to raise_error("stopped waiting after #{max_attempts} attempts without success")
    end

    it 'should write the status to stdout' do
      expect(stdout).to receive(:puts).with("Instance State is #{is_running}.")
      allow(aws_ec2_client).to receive(:describe_instance_status).and_return(create_status_result(is_stopped))
      PollInstanceState.new(config, instance_id, is_stopped, options).execute
    end

  end

  def create_status_result(status)
    Aws::EC2::Types::DescribeInstanceStatusResult.new(
      instance_statuses: [
        Aws::EC2::Types::InstanceStatus.new(instance_state: Aws::EC2::Types::InstanceState.new(name: status))
      ])
  end

end