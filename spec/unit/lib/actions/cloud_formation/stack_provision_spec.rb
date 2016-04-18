require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::StackProvision do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client, aws_s3_client: aws_s3_client) }

  let(:stack_upload_template) { instance_double(AwsHelpers::Actions::S3::UploadTemplate) }
  let(:stack_rollback_complete) { instance_double(AwsHelpers::Actions::CloudFormation::StackRollbackComplete) }
  let(:stack_delete) { instance_double(AwsHelpers::Actions::CloudFormation::StackDelete) }

  let(:stack_request_url) { instance_double(AwsHelpers::Actions::CloudFormation::StackCreateRequestBuilder) }
  let(:stack_request_body) { instance_double(AwsHelpers::Actions::CloudFormation::StackCreateRequestBuilder) }

  let(:stack_information) { instance_double(AwsHelpers::Actions::CloudFormation::StackInformation) }
  let(:stack_exists) { instance_double(AwsHelpers::Actions::CloudFormation::StackExists) }
  let(:stack_update) { instance_double(AwsHelpers::Actions::CloudFormation::StackUpdate) }
  let(:stack_create) { instance_double(AwsHelpers::Actions::CloudFormation::StackCreate) }

  let(:stdout) { instance_double(IO) }

  let(:stack_name) { 'my_stack_name' }
  let(:template_json) { 'json' }
  let(:capabilities) { ['CAPABILITY_IAM'] }

  let(:stack_rolledback) { create_response(stack_name, 'ROLLBACK_COMPLETE') }
  let(:stack_created) { create_response(stack_name, 'CREATE_COMPLETE') }

  let(:parameters) do
    [
        Aws::CloudFormation::Types::Parameter.new(parameter_key: 'param_key_1', parameter_value: 'param_value_1')
    ]
  end
  let(:outputs) { Aws::CloudFormation::Types::Output.new(output_key: 'output_key', output_value: 'output_value', description: nil) }

  let(:s3_bucket_name) { 'my bucket' }
  let(:bucket_encrypt) { true }
  let(:url) { 'https://my-bucket-url' }

  let(:request_with_url) do
    {
        stack_name: stack_name,
        template_url: url,
        parameters: parameters,
        capabilities: capabilities
    }
  end

  let(:request_with_body) do
    {
        stack_name: stack_name,
        template_body: template_json,
        parameters: parameters,
        capabilities: capabilities
    }
  end

  let(:stack_exists_true) { true }
  let(:stack_exists_false) { false }

  context 'template upload required' do
    before(:each) do
      allow(AwsHelpers::Actions::S3::UploadTemplate).to receive(:new).and_return(stack_upload_template)
      allow(stack_upload_template).to receive(:execute).and_return(url)
      allow(cloudformation_client).to receive(:describe_stacks).and_return(stack_rolledback)
      allow(AwsHelpers::Actions::CloudFormation::StackDelete).to receive(:new).and_return(stack_delete)
      allow(stack_delete).to receive(:execute)
      allow(AwsHelpers::Actions::CloudFormation::StackCreateRequestBuilder).to receive(:new).and_return(stack_request_body)
      allow(stack_request_body).to receive(:execute).and_return(request_with_url)
      allow(AwsHelpers::Actions::CloudFormation::StackExists).to receive(:new).and_return(stack_exists)
      allow(stack_exists).to receive(:execute).and_return(stack_exists_true)
      allow(AwsHelpers::Actions::CloudFormation::StackUpdate).to receive(:new).and_return(stack_update)
      allow(stack_update).to receive(:execute)
      allow(AwsHelpers::Actions::CloudFormation::StackCreate).to receive(:new).and_return(stack_create)
      allow(stack_create).to receive(:execute)
      allow(AwsHelpers::Actions::CloudFormation::StackInformation).to receive(:new).and_return(stack_information)
      allow(stack_information).to receive(:execute).and_return(outputs)
    end

    after(:each) do
      described_class.new(config, stack_name, template_json, s3_bucket_name: s3_bucket_name).execute
    end

    it 'should upload the template if the s3_bucket_name is not nil' do
      expect(stack_upload_template).to receive(:execute)
    end

    it 'should check if the stack is in rolled-back state' do
      expect(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(stack_rolledback)
    end

    it 'should call stack delete if the stack is in rolled-back state' do
      expect(stack_delete).to receive(:execute)
    end

    it 'should create the stack creation request' do
      expect(stack_request_body).to receive(:execute).and_return(request_with_url)
    end

    it 'should check if the stack exists' do
      expect(stack_exists).to receive(:execute).and_return(stack_exists_true)
    end

    it 'should call update stack if the stack already exists' do
      expect(stack_update).to receive(:execute)
    end

    it 'should call create stack if the stack does not exists' do
      allow(AwsHelpers::Actions::CloudFormation::StackExists).to receive(:new).with(config, stack_name).and_return(stack_exists)
      allow(stack_exists).to receive(:execute).and_return(stack_exists_false)
      expect(stack_create).to receive(:execute)
    end

    it 'should return the outputs' do
      expect(AwsHelpers::Actions::CloudFormation::StackProvision.new(config, stack_name, template_json).execute).to eq(outputs)
    end
  end

  context 'no template upload required' do
    it 'should return a request template with template_body embedded' do
      allow(stdout).to receive(:puts)
      allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(stack_created)
      allow(AwsHelpers::Actions::CloudFormation::StackCreateRequestBuilder).to receive(:new).and_return(stack_request_body)
      expect(stack_request_body).to receive(:execute).and_return(request_with_body)
      allow(AwsHelpers::Actions::CloudFormation::StackUpdate).to receive(:new).and_return(stack_update)
      allow(stack_update).to receive(:execute)
      allow(AwsHelpers::Actions::CloudFormation::StackInformation).to receive(:new).and_return(stack_information)
      allow(stack_information).to receive(:execute).and_return(outputs)
      AwsHelpers::Actions::CloudFormation::StackProvision.new(config, stack_name, template_json).execute
    end
  end

  def create_response(name, status)
    Aws::CloudFormation::Types::DescribeStacksOutput.new(
        stacks: [
            Aws::CloudFormation::Types::Stack.new(stack_name: name, stack_status: status)
        ])
  end
end
