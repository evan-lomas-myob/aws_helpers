require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/utilities/target_stack_validate'
require 'aws_helpers/actions/cloud_formation/poll_stack_status'

describe AwsHelpers::Actions::CloudFormation::PollStackStatus do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stdout) { instance_double(IO) }
  let(:target_stack_validate) { instance_double(AwsHelpers::Utilities::TargetStackValidate) }

  describe '#execute' do
    before(:each) do
      allow(AwsHelpers::Utilities::TargetStackValidate).to receive(:new).and_return(target_stack_validate)
      allow(stdout).to receive(:puts)
    end

    context 'with stack_id as a parameter' do

      let(:stack_id) { 'id' }

      before(:each) do
        allow(target_stack_validate).to receive(:execute).and_return(stack_id)
      end

      subject { described_class.new(config, stack_id: stack_id, stdout: stdout, max_attempts: 1, delay: 0).execute }

      it 'should call AwsHelpers::Utilities::TargetStackValidate #execute to get the stack name' do
        allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_id).and_return(create_stack_ouput(stack_id, 'CREATE_COMPLETE'))
        expect(target_stack_validate).to receive(:execute).with(hash_including(stack_id: stack_id))
        subject
      end

    end

    context 'with stack_name as a parameter' do

      let(:stack_name) { 'name' }

      before(:each) do
        allow(target_stack_validate).to receive(:execute).and_return(stack_name)
      end

      subject { described_class.new(config, stack_name: stack_name, stdout: stdout, max_attempts: 1, delay: 0).execute }

      it 'should call AwsHelpers::Utilities::TargetStackValidate #execute to get the stack name' do
        allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(create_stack_ouput(stack_name, 'CREATE_COMPLETE'))
        expect(target_stack_validate).to receive(:execute).with(hash_including(stack_name: stack_name))
        subject
      end

      finished_states = %w(CREATE_COMPLETE DELETE_COMPLETE ROLLBACK_COMPLETE UPDATE_COMPLETE UPDATE_ROLLBACK_COMPLETE ROLLBACK_FAILED UPDATE_ROLLBACK_FAILED DELETE_FAILED)
      finished_states.each do |state|

        it "should poll until #{state}" do
          expect(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(create_stack_ouput(stack_name, state))
          subject
        end

      end

      it 'should write to stdout the status of the stack' do
        status = 'CREATE_COMPLETE'
        allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(create_stack_ouput(stack_name, status))
        expect(stdout).to receive(:puts).with("Stack - #{stack_name} status #{status}")
        subject
      end

      it 'should throw an error if max attempts is reached with no finished states' do
        allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(create_stack_ouput(stack_name, 'OTHER_STATE'))
        expect { subject }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
      end

    end

  end

  def create_stack_ouput(stack_name, status)
    Aws::CloudFormation::Types::DescribeStacksOutput.new(
        stacks: [
            Aws::CloudFormation::Types::Stack.new(stack_name: stack_name, stack_status: status)
        ])
  end

end
