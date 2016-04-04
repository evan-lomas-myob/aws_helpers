require 'aws-sdk-core'
require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_describe_change_set'

describe StackDescribeChangeSet do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stdout) { instance_double(IO) }

  let(:target) { instance_double(Aws::CloudFormation::Types::ResourceTargetDefinition, attribute: 'attribute', name: 'attribute name') }
  let(:details) { instance_double(Aws::CloudFormation::Types::ResourceChangeDetail, target: target) }
  let(:resource_change) { instance_double(Aws::CloudFormation::Types::ResourceChange, action: 'action', logical_resource_id: 'logical resource id', replacement: true, details: [details]) }
  let(:changes) { instance_double(Aws::CloudFormation::Types::Change, resource_change: resource_change) }

  let(:empty_describe_output) { instance_double(Aws::CloudFormation::Types::DescribeChangeSetOutput, changes: []) }
  let(:changed_describe_output) { instance_double(Aws::CloudFormation::Types::DescribeChangeSetOutput, changes: [changes]) }

  let(:stack_name) { 'my_stack_name' }
  let(:change_set_name) { 'change_set_name' }

  let(:request) do
    {
      stack_name: stack_name,
      change_set_name: change_set_name
    }
  end

  let(:options) { { stdout: stdout } }

  let(:output) do
    "Action: action\nResource: logical resource id\nReplacement: true\n\tAttribute: attribute\n\tName: attribute name\n"
  end

  after(:each) do
    AwsHelpers::Actions::CloudFormation::StackDescribeChangeSet.new(config, stack_name, change_set_name, options).execute
  end

  context 'No Changes found' do
    before(:each) do
      allow(cloudformation_client).to receive(:describe_change_set).with(request).and_return(empty_describe_output)
      allow(stdout).to receive(:puts).with("No changes found in Change Set #{change_set_name}")
    end

    it 'should describe the change set' do
      expect(cloudformation_client).to receive(:describe_change_set).with(request).and_return(empty_describe_output)
    end

    it 'should get a message saying no changes found' do
      expect(stdout).to receive(:puts).with("No changes found in Change Set #{change_set_name}")
    end
  end

  context 'Change set has changes' do
    before(:each) do
      allow(cloudformation_client).to receive(:describe_change_set).with(request).and_return(changed_describe_output)
      allow(stdout).to receive(:puts).with(anything)
    end

    it 'should describe the change set' do
      expect(cloudformation_client).to receive(:describe_change_set).with(request).and_return(changed_describe_output)
    end

    it 'should get a message saying no changes found' do
      expect(stdout).to receive(:puts).with(output)
    end
  end
end
