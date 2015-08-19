require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers/config'
require 'aws_helpers/actions/cloud_formation/poll_stack_update'

include Aws::CloudFormation::Types
include AwsHelpers::Actions::CloudFormation

describe PollStackUpdate do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stdout) { instance_double(IO) }

  let(:stack_resource) { instance_double(Aws::CloudFormation::Stack) }

  let(:stdout) { instance_double(IO) }
  let(:stack_name) { 'my_stack_name' }

  let(:max_attempts) { 2 }
  let(:delay) { 1 }

  let(:response_create_progress) { 'CREATE_IN_PROGRESS' }
  let(:response_create_complete) { 'CREATE_COMPLETE' }

  let(:create_progress_output) { "Stack - #{stack_name} status #{response_create_progress}" }
  let(:create_complete_output) { "Stack - #{stack_name} status #{response_create_complete}" }

  let(:stack_progress) { [instance_double(Stack, stack_name: stack_name, stack_status: response_create_progress)] }
  let(:stack_complete) { [instance_double(Stack, stack_name: stack_name, stack_status: response_create_complete)] }

  let(:describe_stack_progress) { instance_double(DescribeStacksOutput, stacks: stack_progress) }
  let(:describe_stack_complete) { instance_double(DescribeStacksOutput, stacks: stack_complete) }

  describe '#execute' do

    context 'Polling Completes Successfully' do

      it 'should poll for create stack completed' do
        allow(stdout).to receive(:puts).with(create_progress_output)
        allow(stdout).to receive(:puts).with(create_complete_output)
        expect(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(describe_stack_progress, describe_stack_complete)
        PollStackUpdate.new(config, stack_name, max_attempts, delay, stdout).execute
      end

    end

    context 'Polling Timed Out' do

      it 'should throw an error if expected number of servers is not reached by the retry period' do
        allow(stdout).to receive(:puts).with(anything)
        allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(describe_stack_progress, describe_stack_progress, describe_stack_progress)
        expect{ PollStackUpdate.new(config, stack_name, max_attempts, delay, stdout).execute }.to raise_error("stopped waiting after #{max_attempts} attempts without success")
      end

    end
  end
end