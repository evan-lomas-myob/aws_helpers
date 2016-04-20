require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::StackModifyParameters do

  describe '#execute' do

    let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
    let(:stdout) { instance_double(IO) }
    let(:stack_parameter_update_builder) { instance_double(AwsHelpers::Actions::CloudFormation::StackParameterUpdateBuilder) }
    let(:stack_progress) { instance_double(AwsHelpers::Actions::CloudFormation::StackProgress) }

    let(:stack_id) { 'id' }
    let(:stack_name) { 'name' }
    let(:options) { {stdout: stdout, max_attempts: 1, delay: 2} }
    let(:existing_parameters) { [Aws::CloudFormation::Types::Parameter.new(parameter_key: 'param_key', parameter_value: 'param_value')] }
    let(:update_parameters) { [Aws::CloudFormation::Types::Parameter.new(parameter_key: 'param_key', parameter_value: 'param_value2')] }
    let(:stack_response) {
      Aws::CloudFormation::Types::DescribeStacksOutput.new(
          stacks: [
              Aws::CloudFormation::Types::Stack.new(
                  stack_name: stack_name,
                  parameters: existing_parameters)
          ])
    }

    before(:each) do
      allow(cloudformation_client).to receive(:describe_stacks).and_return(stack_response)
      allow(AwsHelpers::Actions::CloudFormation::StackParameterUpdateBuilder).to receive(:new).and_return(stack_parameter_update_builder)
      allow(stdout).to receive(:puts)
    end

    after(:each) do
      AwsHelpers::Actions::CloudFormation::StackModifyParameters.new(config, stack_name, update_parameters, options).execute
    end

    context 'AwsHelpers::Actions::CloudFormation::StackParameterUpdateBuilder #execute returns nil' do

      before(:each) do
        allow(stack_parameter_update_builder).to receive(:execute).and_return(nil)
      end

      it 'should call Aws::CloudFormation::Client #describe_stacks with stack_name' do
        expect(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name)
      end

      it 'should return a no matching parameters message' do
        expect(stdout).to receive(:puts).with('No matching parameter(s) found')
      end

    end

    context 'AwsHelpers::Actions::CloudFormation::StackParameterUpdateBuilder #execute returns parameters to update' do

      let(:stack_parameter_update_builder_response) {
        {stack_name: stack_name, use_previous_template: true, parameters: update_parameters, capabilities: nil}
      }

      before(:each) do
        allow(stack_parameter_update_builder).to receive(:execute).and_return(stack_parameter_update_builder_response)
        allow(cloudformation_client).to receive(:update_stack).and_return(Aws::CloudFormation::Types::UpdateStackOutput.new(stack_id: stack_id))
        allow(AwsHelpers::Actions::CloudFormation::StackProgress).to receive(:new).and_return(stack_progress)
        allow(stack_progress).to receive(:execute)
      end

      it 'should call stdout puts that the stack is to be updated' do
        expect(stdout).to receive(:puts).with("Updating #{stack_name}")
      end

      it 'should call Aws::CloudFormation::Client #update_stack with correct parameters' do
        expect(cloudformation_client).to receive(:update_stack).with(stack_parameter_update_builder_response)
      end

      it 'should call AwsHelpers::Actions::CloudFormation::StackProgress #new with correct parameters' do
        expect(AwsHelpers::Actions::CloudFormation::StackProgress).to receive(:new).with(config, stack_id, options)
      end

      it 'should call AwsHelpers::Actions::CloudFormation::StackProgress #new with correct parameters' do
        expect(stack_progress).to receive(:execute)
      end

    end
  end
end
