require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::StackCreate do
  let(:cloud_formation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloud_formation_client) }
  let(:stack_progress) { instance_double(AwsHelpers::Actions::CloudFormation::StackProgress) }
  let(:stdout) { instance_double(IO) }
  let(:options) { {stdout: stdout, delay: 1, max_attempts: 2} }

  let(:stack_id) { 'id' }
  let(:stack_name) { 'name' }
  let(:request) do
    {
        stack_name: stack_name,
        s3_template_url: 'https://my-bucket-url',
        parameters: [{parameter_key: 'param_key_1', parameter_value: 'param_value_1'}],
        capabilities: ['CAPABILITY_IAM']
    }
  end

  before(:each) do
    allow(stdout).to receive(:puts)
    allow(cloud_formation_client).to receive(:create_stack).and_return(Aws::CloudFormation::Types::CreateStackOutput.new(stack_id: stack_id))
    allow(AwsHelpers::Actions::CloudFormation::StackProgress).to receive(:new).and_return(stack_progress)
    allow(stack_progress).to receive(:execute)
  end

  after(:each) do
    described_class.new(config, request, options).execute
  end

  it 'should call stdout #puts with stack creation details' do
    expect(stdout).to receive(:puts).with("Creating #{stack_name}")
  end

  it 'should call Aws::CloudFormation::Client #create_stack with correct parameters' do
    expect(cloud_formation_client).to receive(:create_stack).with(request)
  end

  it 'should call AwsHelpers::Actions::CloudFormation::StackProgress #new with correct parameters' do
    expect(AwsHelpers::Actions::CloudFormation::StackProgress).to receive(:new).with(config, stack_id, options)
  end

  it 'should call AwsHelpers::Actions::CloudFormation::StackProgress #execute' do
    expect(stack_progress).to receive(:execute)
  end
end
