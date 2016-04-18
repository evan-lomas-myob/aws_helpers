require 'aws-sdk-core'
require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::PollStackStatus do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stdout) { instance_double(IO) }

  let(:stack_id) { 'id' }

  describe '#execute' do

    before(:each) do
       allow(stdout).to receive(:puts)
    end

    subject { described_class.new(config, stack_id, stdout: stdout, max_attempts: 1, delay: 0).execute }

    finished_states = %w(CREATE_COMPLETE DELETE_COMPLETE ROLLBACK_COMPLETE UPDATE_COMPLETE UPDATE_ROLLBACK_COMPLETE ROLLBACK_FAILED UPDATE_ROLLBACK_FAILED DELETE_FAILED)
    finished_states.each do |state|
      it "should poll until #{state}" do
        expect(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_id).and_return(create_stack_ouput(stack_id, state))
        subject
      end
    end

    it 'should write to stdout the status of the stack' do
      allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_id).and_return(create_stack_ouput(stack_id, 'CREATE_COMPLETE'))
      expect(stdout).to receive(:puts).with('Stack - name status CREATE_COMPLETE')
      subject
    end

    it 'should throw an error if max attempts is reached with no finished states' do
      allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_id).and_return(create_stack_ouput(stack_id, 'OTHER_STATE'))
      expect { subject }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
    end

  end

  def create_stack_ouput(stack_id, status)
    Aws::CloudFormation::Types::DescribeStacksOutput.new(
        stacks: [
            Aws::CloudFormation::Types::Stack.new(stack_name: 'name', stack_id: stack_id, stack_status: status)
        ])
  end
end
