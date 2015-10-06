require 'aws-sdk-core'
require 'aws-sdk-resources'

require 'aws_helpers/config'
require 'aws_helpers/actions/ec2/instance_terminate'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe InstanceTerminate do

  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
  let(:stdout) { instance_double(IO) }

  let(:instance_id) { 'my-instance-id'}


  let(:terminating_instances) { [ instance_double(Aws::EC2::Types::InstanceStateChange, instance_id: instance_id) ] }
  let(:terminate_result) { instance_double(Aws::EC2::Types::TerminateInstancesResult, terminating_instances: terminating_instances)}

  it 'should terminate and instance' do
    allow(stdout).to receive(:puts).with("Terminating #{instance_id}")
    expect(aws_ec2_client).to receive(:terminate_instances).with(instance_ids: [instance_id]).and_return(terminate_result)
    InstanceTerminate.new(config, instance_id, stdout).execute
  end
end