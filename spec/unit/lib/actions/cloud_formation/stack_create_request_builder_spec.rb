require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_create_request_builder'

include Aws::CloudFormation::Types
include AwsHelpers
include AwsHelpers::Actions::CloudFormation

describe StackCreateRequestBuilder do

  let(:stack_name) { 'my_stack_name' }
  let(:s3_bucket_url) { instance_double(S3BucketUrl) }
  let(:template_json) { 'json' }
  let(:parameters) { [
      Parameter.new(parameter_key: 'param_key_1', parameter_value: 'param_value_1'),
      Parameter.new(parameter_key: 'param_key_2', parameter_value: 'param_value_1')
  ] }
  let(:capabilities) { ["CAPABILITY_IAM"] }

  let(:request_with_url) { {stack_name: stack_name,
                            s3_bucket_url: s3_bucket_url,
                            parameters: parameters,
                            capabilities: capabilities
  } }

  let(:request_without_url) { {stack_name: stack_name,
                               template_json: template_json,
                               parameters: parameters,
                               capabilities: capabilities
  } }

  it 'should create the request hash with the s3 bucket url' do
    expect(StackCreateRequestBuilder.new(stack_name, s3_bucket_url, template_json, parameters, capabilities).execute).to eq(request_with_url)
  end

  it 'should create the request hash with the json template' do
    expect(StackCreateRequestBuilder.new(stack_name, nil, template_json, parameters, capabilities).execute).to eq(request_without_url)
  end

end