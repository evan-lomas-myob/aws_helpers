require 'aws_helpers/actions/cloud_formation/stack_create_request_builder'

describe AwsHelpers::Actions::CloudFormation::StackCreateRequestBuilder do
  let(:stack_name) { 'my_stack_name' }
  let(:s3_template_url) { 'url' }
  let(:template_json) { 'json' }
  let(:parameters) { [{parameter_key: 'key', parameter_value: 'value'}] }
  let(:capabilities) { ['CAPABILITY_IAM'] }

  let(:request_with_url) do
    {
        stack_name: stack_name,
        template_url: s3_template_url,
        parameters: parameters,
        capabilities: capabilities
    }
  end

  let(:request_without_url) do
    {
        stack_name: stack_name,
        template_body: template_json,
        parameters: parameters,
        capabilities: capabilities
    }
  end

  it 'should create the request hash with the s3 bucket url' do
    expect(described_class.new(stack_name, s3_template_url, template_json, parameters, capabilities).execute).to eq(request_with_url)
  end

  it 'should create the request hash with the json template' do
    expect(described_class.new(stack_name, nil, template_json, parameters, capabilities).execute).to eq(request_without_url)
  end

end
