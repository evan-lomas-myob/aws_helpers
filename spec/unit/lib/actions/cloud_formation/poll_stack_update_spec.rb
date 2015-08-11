require 'aws_helpers/config'
require 'aws_helpers/actions/cloud_formation/poll_stack_update'

include AwsHelpers::Actions::CloudFormation

describe PollStackUpdate do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stdout) { instance_double(IO) }
  let(:waiter) { instance_double(Aws::Waiters::Waiter, delay: 15, max_attempts: 40) }
  let(:stack_name) { 'my_stack_name' }
  let(:response) { double(stack_status: 'UPDATE_COMPLETE') }

  describe '#execute' do

    before(:each) do
      allow(cloudformation_client).to receive(:wait_until).and_yield(waiter)
      allow(waiter).to receive(:max_attempts=)
      allow(waiter).to receive(:before_wait).and_yield(1, response)
      allow(stdout).to receive(:puts)
    end

    it 'should call describe wait_until with correct parameters on the Aws::CloudFormation::Client' do
      expect(cloudformation_client).to receive(:wait_until).with(:stack_update_complete, stack_name: stack_name)
      PollStackUpdate.new(stdout, config, stack_name, 60).execute
    end

    it 'should set the waiters max attempts to 4' do
      expect(waiter).to receive(:max_attempts=).with(4)
      PollStackUpdate.new(stdout, config, stack_name, 60).execute
    end

    it 'log to stdout' do
      expect(stdout).to receive(:puts).with('Stack - my_stack_name status UPDATE_COMPLETE')
      PollStackUpdate.new(stdout, config, stack_name, 60).execute
    end

  end
end