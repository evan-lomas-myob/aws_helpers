require 'aws-sdk-core'
require 'aws_helpers/utilities/target_stack_validate'

describe AwsHelpers::Utilities::TargetStackValidate do
  let(:stack_name) { 'my_stack_name' }
  let(:stack_id) { "arn:aws:cloudformation:region:id:stack/#{stack_name}/stack_id_number" }

  let(:stack_name_options) { { stack_name: stack_name } }
  let(:stack_id_options) { { stack_id: stack_id } }

  let(:stack_validator) { AwsHelpers::Utilities::TargetStackValidate.new }

  it 'should return the stack name' do
    expect(stack_validator.execute(stack_name_options)).to eq(stack_name)
  end

  it 'should return the stack id' do
    expect(stack_validator.execute(stack_id_options)).to eq(stack_id)
  end

  it "should raise exception if a stack name or stack id doesn't exist" do
    expect { stack_validator.execute({}) }.to raise_error(RuntimeError, 'You must supply and options[:stack_name] or options[:stack_id]')
  end
end
