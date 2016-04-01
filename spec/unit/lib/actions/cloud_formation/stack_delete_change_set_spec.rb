require 'aws-sdk-core'
require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_delete_change_set'

describe StackDeleteChangeSet do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stdout) { instance_double(IO) }

  let(:stack_name) { 'my_stack_name' }
  let(:change_set_name) { 'change_set_name' }

  let(:request) do
    {
        stack_name: stack_name,
        change_set_name: change_set_name
    }
  end

  let(:options) { {stdout: stdout} }

  before(:each) do
    allow(stdout).to receive(:puts).with("Deleting Change Set #{change_set_name}")
    allow(cloudformation_client).to receive(:delete_change_set).with(request)
  end

  after(:each) do
    AwsHelpers::Actions::CloudFormation::StackDeleteChangeSet.new(config, stack_name, change_set_name, options).execute
  end

  it 'should delete the change set' do
    expect(cloudformation_client).to receive(:delete_change_set).with(request)
  end

  it 'should post a message to stdout' do
    expect(stdout).to receive(:puts).with("Deleting Change Set #{change_set_name}")
  end
end
