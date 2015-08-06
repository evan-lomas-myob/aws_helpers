require 'aws_helpers/cloud_formation'

describe AwsHelpers::CloudFormation do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(AwsHelpers::Config) }
  let(:stack_name) { 'my_stack_name' }

  describe '#initialize' do

    it 'should call AwsHelpers::Client initialize method' do
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::CloudFormation.new(options)
    end

  end

  describe '#stack_provision' do

    let(:stack_provision) { double(StackProvision) }

    let(:template) { 'my_stack_template' }

    let(:default_parameters) { nil }
    let(:default_capabilities) { nil }
    let(:default_bucket_name) { nil }
    let(:default_bucket_encrypt) { false }

    let(:parameters) { 'my_stack_parameters' }
    let(:capabilities) { 'my_capabilities' }
    let(:bucket_name) { 'my_bucket_name' }
    let(:bucket_encrypt) { true }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(StackProvision).to receive(:new).with(anything,
                                                  anything,
                                                  anything,
                                                  anything,
                                                  anything,
                                                  anything,
                                                  anything).and_return(stack_provision)
      allow(stack_provision).to receive(:execute)
    end

    it 'should create StackProvision with stack_name,template and defaults' do

      expect(StackProvision).to receive(:new).with(config,
                                                   stack_name,
                                                   template,
                                                   default_parameters,
                                                   default_capabilities,
                                                   default_bucket_name,
                                                   default_bucket_encrypt).and_return(stack_provision)

      AwsHelpers::CloudFormation.new(options).stack_provision(
          stack_name: stack_name,
          template: template)

    end

    it 'should create StackProvision with stack_name,template and other values defined' do

      expect(StackProvision).to receive(:new).with(config,
                                                   stack_name,
                                                   template,
                                                   parameters,
                                                   capabilities,
                                                   bucket_name,
                                                   bucket_encrypt).and_return(stack_provision)

      AwsHelpers::CloudFormation.new(options).stack_provision(
          stack_name: stack_name,
          template: template,
          parameters: parameters,
          capabilities: capabilities,
          bucket_name: bucket_name,
          bucket_encrypt: bucket_encrypt)

    end

    it 'should call StackProvision execute method' do
      expect(stack_provision).to receive(:execute)
      AwsHelpers::CloudFormation.new(options).stack_provision(
          stack_name: stack_name,
          template: template)
    end

    it 'should call StackProvision execute method with values' do
      expect(stack_provision).to receive(:execute)
      AwsHelpers::CloudFormation.new(options).stack_provision(
          stack_name: stack_name,
          template: template,
          parameters: parameters,
          capabilities: capabilities,
          bucket_name: bucket_name,
          bucket_encrypt: bucket_encrypt)
    end

  end

  describe '#stack_delete' do

    let(:stack_delete) { double(StackDelete) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(StackDelete).to receive(:new).with(anything, anything).and_return(stack_delete)
      allow(stack_delete).to receive(:execute)
    end

    subject { AwsHelpers::CloudFormation.new(options).stack_delete(stack_name: stack_name) }

    it 'should create StackDelete with stack name as argument' do
      expect(StackDelete).to receive(:new).with(config, stack_name)
      subject
    end

    it 'should call StackDelete execute method' do
      expect(stack_delete).to receive(:execute)
      subject
    end

  end

  describe '#stack_exists' do

    let(:stack_exists) { double(StackExists) }

    let(:the_stack_exists) { true }
    let(:the_stack_does_not_exist) { false }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(StackExists).to receive(:new).with(anything, anything).and_return(stack_exists)
      allow(stack_exists).to receive(:execute)
    end

    subject { AwsHelpers::CloudFormation.new(options).stack_exists?(stack_name: stack_name) }

    it 'should create StackExists with correct parameters ' do
      expect(StackExists).to receive(:new).with(config, stack_name)
      subject
    end

    it 'should call StackExists execute method' do
      expect(stack_exists).to receive(:execute)
      subject
    end

    it 'should return true is the stack exists' do
      allow(stack_exists).to receive(:execute).with(stack_name: stack_name).and_return(true)
      # Add expect
    end

    it 'should return false if the stack does not exist' do
      allow(stack_exists).to receive(:execute).with(stack_name: stack_name).and_return(false)
      # Add expect
    end

  end

  describe '#stack_information' do

    let(:stack_information) { double(StackInformation) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(StackInformation).to receive(:new).with(anything, anything, anything).and_return(stack_information)
      allow(stack_information).to receive(:execute)
    end

    context 'defaults' do

      it 'should call StackInformation execute method' do
        expect(stack_information).to receive(:execute)
        AwsHelpers::CloudFormation.new(options).stack_information(stack_name: stack_name)
      end

      it 'should create StackInformation with default parameters info_field' do
        expect(StackInformation).to receive(:new).with(config, stack_name, 'parameters')
        AwsHelpers::CloudFormation.new(options).stack_information(stack_name: stack_name)
      end

    end

    context 'info_field is parameters' do

      let(:info_field) { 'parameters' }

      it 'should create StackInformation using parameters info_field' do
        expect(StackInformation).to receive(:new).with(config, stack_name, info_field)
        AwsHelpers::CloudFormation.new(options).stack_information(stack_name: stack_name, info_field: info_field)
      end

    end

    context 'info_field is output' do

      let(:info_field) { 'outputs' }

      it 'should create StackInformation using output info_field' do
        expect(StackInformation).to receive(:new).with(config, stack_name, info_field)
        AwsHelpers::CloudFormation.new(options).stack_information(stack_name: stack_name, info_field: info_field)
      end

    end

  end

  describe '#stack_modify_parameters' do

    let(:stack_modify_parameters) { double(StackModifyParameters) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(StackModifyParameters).to receive(:new).with(anything, anything, anything).and_return(stack_modify_parameters)
      allow(stack_modify_parameters).to receive(:execute)
    end

    let(:parameters) { %w('parameter1','parameter2') }

    it 'should create StackModifyParameters' do
      expect(StackModifyParameters).to receive(:new).with(config, stack_name, parameters)
      AwsHelpers::CloudFormation.new(options).stack_modify_parameters(stack_name: stack_name, parameters: parameters)
    end

    it 'should call StackModifyParameters execute method' do
      expect(stack_modify_parameters).to receive(:execute)
      AwsHelpers::CloudFormation.new(options).stack_modify_parameters(stack_name: stack_name, parameters: parameters)
    end

  end

end
