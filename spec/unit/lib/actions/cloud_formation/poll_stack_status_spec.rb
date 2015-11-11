require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers/config'
require 'aws_helpers/utilities/target_stack_validate'
require 'aws_helpers/actions/cloud_formation/poll_stack_status'

include Aws::CloudFormation::Types
include AwsHelpers::Actions::CloudFormation

describe PollStackStatus do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stdout) { instance_double(IO) }

  let(:stack_resource) { instance_double(Aws::CloudFormation::Stack) }
  let(:target_stack_validate) { instance_double(AwsHelpers::Utilities::TargetStackValidate) }

  let(:stdout) { instance_double(IO) }

  let(:max_attempts) { 2 }
  let(:delay) { 0 }

  let(:bad_options) { {stdout: stdout, max_attempts: max_attempts, delay: delay} }

  let(:stack_name) { 'my_stack_name' }
  let(:stack_id) { "arn:aws:cloudformation:region:id:stack/#{stack_name}/stack_id_number" }

  let(:stack_name_options) { {stack_name: stack_name, stdout: stdout, max_attempts: max_attempts, delay: delay} }
  let(:stack_id_options) { {stack_id: stack_id, stdout: stdout, max_attempts: max_attempts, delay: delay} }

  let(:response_create_progress) { 'CREATE_IN_PROGRESS' }
  let(:response_create_complete) { 'CREATE_COMPLETE' }

  let(:create_progress_output) { "Stack - #{stack_name} status #{response_create_progress}" }
  let(:create_complete_output) { "Stack - #{stack_name} status #{response_create_complete}" }

  let(:stack_progress) { [instance_double(Stack, stack_name: stack_name, stack_status: response_create_progress)] }
  let(:stack_complete) { [instance_double(Stack, stack_name: stack_name, stack_status: response_create_complete)] }

  let(:describe_stack_progress) { instance_double(DescribeStacksOutput, stacks: stack_progress) }
  let(:describe_stack_complete) { instance_double(DescribeStacksOutput, stacks: stack_complete) }

  describe '#execute' do

    before(:each) do
      allow(AwsHelpers::Utilities::TargetStackValidate).to receive(:new).and_return(target_stack_validate)
      allow(target_stack_validate).to receive(:execute).with(stack_name_options).and_return(stack_name)
    end

    context 'Polling Completes Successfully' do
      it 'should poll for create stack completed' do
        allow(stdout).to receive(:puts).with(create_progress_output)
        allow(stdout).to receive(:puts).with(create_complete_output)
        expect(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(describe_stack_progress, describe_stack_complete)
        PollStackStatus.new(config, stack_name_options).execute
      end

    end

    context 'Polling Timed Out' do

      it 'should throw an error if expected number of servers is not reached by the retry period' do
        allow(stdout).to receive(:puts).with(anything)
        allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(describe_stack_progress, describe_stack_progress, describe_stack_progress)
        expect { PollStackStatus.new(config, stack_name_options).execute }.to raise_error("stopped waiting after #{max_attempts} attempts without success")
      end

    end
  end
end