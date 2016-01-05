require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers'
require 'aws_helpers/actions/ec2/poll_instance_healthy'

include AwsHelpers::Actions::EC2

describe PollInstanceHealthy do

  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }

  let(:running_state) { instance_double(Aws::EC2::Types::InstanceState, name: 'running') }
  let(:pending_state) { instance_double(Aws::EC2::Types::InstanceState, name: 'pending') }

  let(:ok_state) { instance_double(Aws::EC2::Types::InstanceStatusSummary, status: 'ok') }
  let(:init_state) { instance_double(Aws::EC2::Types::InstanceStatusSummary, status: 'initializing') }

  let(:ok_status) { instance_double(Aws::EC2::Types::InstanceStatus, instance_id: instance_id, instance_state: running_state, instance_status: ok_state) }
  let(:init_status) { instance_double(Aws::EC2::Types::InstanceStatus, instance_id: instance_id, instance_state: pending_state, instance_status: init_state) }

  let(:ok_response) { instance_double(Aws::EC2::Types::DescribeInstanceStatusResult, instance_statuses: [ok_status]) }
  let(:init_response) { instance_double(Aws::EC2::Types::DescribeInstanceStatusResult, instance_statuses: [init_status]) }

  let(:windows_instance) { instance_double(Aws::EC2::Types::Instance, platform: 'windows') }
  let(:not_windows_instance) { instance_double(Aws::EC2::Types::Instance, platform: '') }

  let(:windows_reservation) { [instance_double(Aws::EC2::Types::Reservation, instances: [windows_instance])] }
  let(:not_windows_reservation) { [instance_double(Aws::EC2::Types::Reservation, instances: [not_windows_instance])] }

  let(:windows_platform) { instance_double(Aws::EC2::Types::DescribeInstancesResult, reservations: windows_reservation) }
  let(:not_windows_platform) { instance_double(Aws::EC2::Types::DescribeInstancesResult, reservations: not_windows_reservation) }

  let(:instance_id) { 'i-de42f500' }

  let(:stdout) { instance_double(IO) }
  let(:max_attempts) { 3 }
  let(:delay) { 0 }

  let(:options) { {stdout: stdout, delay: delay, max_attempts: max_attempts} }

  describe '#execute' do

    context 'Platform Not Windows' do

      it 'should use the AwsHelpers::Utilities::Polling to poll until the image exists' do
        allow(stdout).to receive(:print).with("Instance State is pending.")
        allow(stdout).to receive(:print).with("Instance State is running.")
        allow(stdout).to receive(:print).with("\n")
        allow(aws_ec2_client).to receive(:describe_instances).and_return(not_windows_platform)
        expect(aws_ec2_client).to receive(:describe_instance_status).and_return(init_response, ok_response)
        PollInstanceHealthy.new(config, instance_id, options).execute
      end

      it 'should raise an exception is polling reaches max attempts' do
        allow(stdout).to receive(:print).with("Instance State is pending.")
        allow(stdout).to receive(:print).with("\n")
        allow(aws_ec2_client).to receive(:describe_instance_status).with(instance_ids: [instance_id]).and_return(init_response)
        allow(aws_ec2_client).to receive(:describe_instances).and_return(not_windows_platform)
        expect { PollInstanceHealthy.new(config, instance_id, options).execute }.to raise_error("stopped waiting after #{max_attempts} attempts without success")
      end

    end

    context 'Platform Is Windows' do

      it 'should use the AwsHelpers::Utilities::Polling to poll until the image exists' do
        allow(stdout).to receive(:print).with("Instance State is pending.")
        allow(stdout).to receive(:print).with("Instance State is running.")
        allow(stdout).to receive(:print).with(" Windows Status is initializing.")
        allow(stdout).to receive(:print).with(" Windows Status is ok.")
        allow(stdout).to receive(:print).with("\n")
        allow(aws_ec2_client).to receive(:describe_instances).and_return(windows_platform)
        expect(aws_ec2_client).to receive(:describe_instance_status).and_return(init_response, ok_response)
        PollInstanceHealthy.new(config, instance_id, options).execute
      end

      it 'should raise an exception is polling reaches max attempts' do
        allow(stdout).to receive(:print).with("Instance State is pending.")
        allow(stdout).to receive(:print).with(" Windows Status is initializing.")
        allow(stdout).to receive(:print).with("\n")
        allow(aws_ec2_client).to receive(:describe_instance_status).with(instance_ids: [instance_id]).and_return(init_response)
        allow(aws_ec2_client).to receive(:describe_instances).and_return(windows_platform)
        expect { PollInstanceHealthy.new(config, instance_id, options).execute }.to raise_error("stopped waiting after #{max_attempts} attempts without success")
      end

    end

  end
end
