require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::StackUpdate do

  describe '#execute' do

    let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
    let(:stack_progress) { instance_double(AwsHelpers::Actions::CloudFormation::StackProgress) }
    let(:stdout) { instance_double(IO) }

    let(:stack_id) { 'id' }
    let(:stack_name) { 'name' }
    let(:options) { {stdout: stdout, delay: 1, max_attempts: 2} }
    let(:request) { {stack_name: stack_name} }

    before(:each) do
      allow(cloudformation_client).to receive(:update_stack).and_return(Aws::CloudFormation::Types::UpdateStackOutput.new(stack_id: stack_id))
      allow(cloudformation_client).to receive(:describe_stacks)
      allow(stdout).to receive(:puts)
      allow(AwsHelpers::Actions::CloudFormation::StackProgress).to receive(:new).and_return(stack_progress)
      allow(stack_progress).to receive(:execute)
    end

    subject { described_class.new(config, request, options).execute }

    context 'Update Stack Succeeds' do
      after(:each) do
        subject
      end

      it 'should call stdout #puts with update details' do
        expect(stdout).to receive(:puts).with("Updating #{stack_name}")
      end

      it 'should call update_stack to update the stack' do
        expect(cloudformation_client).to receive(:update_stack).with(request)
      end

      it 'should call StackProgress #new with the correct parameters' do
        expect(AwsHelpers::Actions::CloudFormation::StackProgress)
            .to receive(:new).with(config, stack_id, options)
      end

      it 'should call StackProgress #execute' do
        expect(stack_progress).to receive(:execute)
      end

      it 'should raise an exception if not updates are required' do
        allow(cloudformation_client).to receive(:update_stack).and_raise(create_error(config, 'No updates are to be performed.'))
        expect(stdout).to receive(:puts).and_return("No updates to perform for #{stack_name}.")
      end
    end

    context 'Update Stack Fails' do

      let(:general_error){create_error(config, 'error')}

      it 'should raise a general exception if validation fails' do
        allow(cloudformation_client).to receive(:update_stack).and_raise(general_error)
        expect { subject }.to raise_error(general_error)
      end
    end

    def create_error(config, message)
      Aws::CloudFormation::Errors::ValidationError.new(config, message)
    end
  end
end