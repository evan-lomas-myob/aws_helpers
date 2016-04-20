require 'aws-sdk-core'
require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::StackDelete do

  describe '#execute' do

    let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
    let(:stack_progress) { instance_double(AwsHelpers::Actions::CloudFormation::StackProgress) }
    let(:stack_exists) { instance_double(AwsHelpers::Actions::CloudFormation::StackExists) }
    let(:stdout) { instance_double(IO) }

    let(:stack_name) { 'name' }
    let(:options) { {stdout: stdout, max_attempts: 1, delay: 2} }

    before(:each) do
      allow(stdout).to receive(:puts)
      allow(AwsHelpers::Actions::CloudFormation::StackExists).to receive(:new).and_return(stack_exists)
      allow(stack_exists).to receive(:execute)
    end

    after(:each) do
      described_class.new(config, stack_name, options).execute
    end

    it 'should call stdout #put with deletion details' do
      expect(stdout).to receive(:puts).with("Deleting #{stack_name}")
    end

    it 'should call AwsHelpers::Actions::CloudFormation::StackExists #new with stack_name' do
      expect(AwsHelpers::Actions::CloudFormation::StackExists).to receive(:new).with(config, stack_name)
    end

    it 'should call AwsHelpers::Actions::CloudFormation::StackExists #execute' do
      expect(stack_exists).to receive(:execute)
    end

    context 'stack does not exists' do

      before(:each) do
        allow(stack_exists).to receive(:execute).and_return(false)
      end

      it 'should not call Aws::CloudFormation::Client #delete_stack' do
        expect(cloudformation_client).to_not receive(:delete_stack)
      end

    end

    context 'stack exists' do

      let(:stack_id) { "arn:aws:cloudformation:region:id:stack/#{stack_name}/stack_id_number" }
      let(:describe_stack_response) {
        Aws::CloudFormation::Types::DescribeStacksOutput.new(
            stacks: [Aws::CloudFormation::Types::Stack.new(stack_name: stack_name, stack_id: stack_id)])
      }

      before(:each) do
        allow(stack_exists).to receive(:execute).and_return(true)
        allow(cloudformation_client).to receive(:describe_stacks).and_return(describe_stack_response)
        allow(cloudformation_client).to receive(:delete_stack)
        allow(AwsHelpers::Actions::CloudFormation::StackProgress).to receive(:new).and_return(stack_progress)
        allow(stack_progress).to receive(:execute)
      end

      it 'should call Aws::CloudFormation::Client #describe_stack with stack_name' do
        expect(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name)
      end

      it 'should call Aws::CloudFormation::Client #delete_stack with correct parameters' do
        expect(cloudformation_client).to receive(:delete_stack).with(stack_name: stack_name)
      end

      it 'should call AwsHelpers::Actions::CloudFormation::StackProgress #new with correct parameters' do
        expect(AwsHelpers::Actions::CloudFormation::StackProgress).to receive(:new).with(config, stack_id, options)
      end

      it 'should call AwsHelpers::Actions::CloudFormation::StackProgress #execute' do
        expect(stack_progress).to receive(:execute)
      end

    end

  end

end
