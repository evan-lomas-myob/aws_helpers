require 'aws-sdk-core'

require 'aws_helpers/config'
require 'aws_helpers/actions/ec2/instance_start'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe InstanceStart do
  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
  let(:poll_instance_healthy) { instance_double(PollInstanceHealthy) }
  let(:stdout) { instance_double(IO) }

  let(:instance_id) { 'i-abcd1234' }

  let(:max_attempts) { 1 }
  let(:delay) { 0 }

  let(:polling_options) { { stdout: stdout, max_attempts: max_attempts, delay: delay } }
  let(:options) { {stdout: stdout, poll_running: {max_attempts: max_attempts, delay: delay } } }

  let(:starting_instances) { [instance_double(Aws::EC2::Types::InstanceStateChange, instance_id: instance_id)] }
  let(:starting_result) { instance_double(Aws::EC2::Types::StartInstancesResult, starting_instances: starting_instances) }

  it 'should start the instance' do
    allow(stdout).to receive(:puts).with("Starting #{instance_id}")
    allow(PollInstanceHealthy).to receive(:new).with(config, instance_id, polling_options).and_return(poll_instance_healthy)
    allow(poll_instance_healthy).to receive(:execute)
    expect(aws_ec2_client).to receive(:start_instances).with(instance_ids: [instance_id]).and_return(starting_result)
    InstanceStart.new(config, instance_id, options).execute
  end
end
