require 'aws-sdk-core'
require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_create_change_set'

describe StackCreateChangeSet do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stdout) { instance_double(IO) }

  let(:stack_name) { 'my_stack_name' }
  let(:change_set_name) { 'change_set_name' }

  let(:template_json) do
    {
        "Resources": {
            "TestInstance": {
                "Type": "AWS::EC2::Instance",
                "Properties": {
                    "ImageId": "ami-f5210196"
                }
            }
        }
    }
  end

  let(:request) do
    {
        stack_name: stack_name,
        template_body: "#{template_json}",
        change_set_name: change_set_name
    }
  end

  let(:options) { {stdout: stdout} }

  before(:each) do
    allow(stdout).to receive(:puts).with("Creating Change Set #{change_set_name}")
    allow(cloudformation_client).to receive(:create_change_set).with(request)
  end

  after(:each) do
    AwsHelpers::Actions::CloudFormation::StackCreateChangeSet.new(config, stack_name, change_set_name, template_json, options).execute
  end

  it 'should create the change set' do
    expect(cloudformation_client).to receive(:create_change_set).with(request)
  end

  it 'should post a message to stdout' do
    expect(stdout).to receive(:puts).with("Creating Change Set #{change_set_name}")
  end
end
