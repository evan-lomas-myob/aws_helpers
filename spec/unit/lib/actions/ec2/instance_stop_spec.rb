require 'aws-sdk-core'

require 'aws_helpers/config'
require 'aws_helpers/actions/ec2/instance_stop'
require 'aws_helpers/actions/ec2/poll_instance_state'


include AwsHelpers
include AwsHelpers::Actions::EC2

describe InstanceStop do

  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
  let(:poll_instance_state) { instance_double(PollInstanceState) }
  let(:stdout) { instance_double(IO) }

  let(:instance_id) { 'i-abcd1234' }

  let(:max_attempts) { 1 }
  let(:delay) { 0 }

  let(:polling_options) { {stdout: stdout, max_attempts: max_attempts, delay: delay} }
  let(:options) { {stdout: stdout, poll_stopped: {max_attempts: max_attempts, delay: delay}} }

  let(:stopping_instances) { [ instance_double(Aws::EC2::Types::InstanceStateChange, instance_id: instance_id) ] }
  let(:stopping_result) { instance_double(Aws::EC2::Types::StopInstancesResult, stopping_instances: stopping_instances)}

  it 'should stop the instance' do
    allow(stdout).to receive(:puts).with("Stopping #{instance_id}")
    allow(PollInstanceState).to receive(:new).with(config, instance_id, 'stopped', polling_options).and_return(poll_instance_state)
    allow(poll_instance_state).to receive(:execute)
    expect(aws_ec2_client).to receive(:stop_instances).with(instance_ids: [instance_id]).and_return(stopping_result)
    InstanceStop.new(config, instance_id, options).execute
  end

end