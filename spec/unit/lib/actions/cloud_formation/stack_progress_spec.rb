require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::StackProgress do

  describe '#execute' do

    let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }

    let(:poll_stack_status) { instance_double(AwsHelpers::Actions::CloudFormation::PollStackStatus) }
    let(:stack_error_events) { instance_double(AwsHelpers::Actions::CloudFormation::StackErrorEvents) }
    let(:check_stack_failure) { instance_double(AwsHelpers::Actions::CloudFormation::CheckStackFailure) }

    let(:stdout) { instance_double(IO) }
    let(:stack_id) { 'id' }
    let(:options) { {stdout: stdout, delay: 1, max_attempts: 2} }

    before(:each) do
      allow(AwsHelpers::Actions::CloudFormation::PollStackStatus).to receive(:new).and_return(poll_stack_status)
      allow(AwsHelpers::Actions::CloudFormation::StackErrorEvents).to receive(:new).and_return(stack_error_events)
      allow(AwsHelpers::Actions::CloudFormation::CheckStackFailure).to receive(:new).and_return(check_stack_failure)
      allow(poll_stack_status).to receive(:execute)
      allow(stack_error_events).to receive(:execute)
      allow(check_stack_failure).to receive(:execute)
    end

    after(:each) do
      described_class.new(config, stack_id, options).execute
    end

    it 'should call PollStackStatus #new with correct parameters' do
      expect(AwsHelpers::Actions::CloudFormation::PollStackStatus).to receive(:new).with(config, stack_id, options)
    end

    it 'should call StackErrorEvents #new with correct parameters' do
      expect(AwsHelpers::Actions::CloudFormation::StackErrorEvents).to receive(:new).with(config, stack_id, stdout: stdout)
    end

    it 'should call CheckStackFailure #new with correct parameters' do
      expect(AwsHelpers::Actions::CloudFormation::CheckStackFailure).to receive(:new).with(config, stack_id)
    end

    it 'should call #execute on PollStackStatus, StackErrorEvents and CheckStackFailure in hte correct order' do
      expect(poll_stack_status).to receive(:execute).ordered
      expect(stack_error_events).to receive(:execute).ordered
      expect(check_stack_failure).to receive(:execute).ordered
    end

  end
end
