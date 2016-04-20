require 'aws_helpers'

describe AwsHelpers::CloudFormation do
  let(:config) { instance_double(AwsHelpers::Config) }
  let(:stdout) { instance_double(IO) }
  let(:stack_name) { 'my_stack_name' }

  describe '#initialize' do
    it 'should call AwsHelpers::Client initialize method' do
      options = {endpoint: 'http://endpoint'}
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::CloudFormation.new(options)
    end
  end

  describe '#stack_provision' do
    let(:stack_provision) { instance_double(AwsHelpers::Actions::CloudFormation::StackProvision) }
    let(:template) { '{"AWSTemplateFormatVersion" : "2010-09-09"}' }
    let(:parameters) { [{parameter_key: 'key', parameter_value: 'value'}] }
    let(:capabilities) { ['CAPABILITY_IAM'] }
    let(:bucket_name) { 'my_bucket_name' }
    let(:bucket_encrypt) { true }
    let(:polling) { {max_attempts: 5, delay: 1} }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(AwsHelpers::Actions::CloudFormation::StackProvision).to receive(:new).and_return(stack_provision)
      allow(stack_provision).to receive(:execute)
    end

    it 'should create StackProvision with default parameters' do
      expect(AwsHelpers::Actions::CloudFormation::StackProvision).to receive(:new).with(config, stack_name, template, {})
      AwsHelpers::CloudFormation.new.stack_provision(stack_name, template)
    end

    it 'should create StackProvision with optional :parameters' do
      expect(AwsHelpers::Actions::CloudFormation::StackProvision).to receive(:new).with(config, stack_name, template, parameters: parameters)
      AwsHelpers::CloudFormation.new.stack_provision(stack_name, template, parameters: parameters)
    end

    it 'should create StackProvision with optional :capabilities' do
      expect(AwsHelpers::Actions::CloudFormation::StackProvision).to receive(:new).with(config, stack_name, template, capabilities: capabilities)
      AwsHelpers::CloudFormation.new.stack_provision(stack_name, template, capabilities: capabilities)
    end

    it 'should create StackProvision with optional :bucket_name' do
      expect(AwsHelpers::Actions::CloudFormation::StackProvision).to receive(:new).with(config, stack_name, template, bucket_name: bucket_name)
      AwsHelpers::CloudFormation.new.stack_provision(stack_name, template, bucket_name: bucket_name)
    end

    it 'should create StackProvision with optional :bucket_encrypt' do
      expect(AwsHelpers::Actions::CloudFormation::StackProvision).to receive(:new).with(config, stack_name, template, bucket_encrypt: bucket_encrypt)
      AwsHelpers::CloudFormation.new.stack_provision(stack_name, template, bucket_encrypt: bucket_encrypt)
    end

    it 'should create StackProvision with optional :stdout' do
      expect(AwsHelpers::Actions::CloudFormation::StackProvision).to receive(:new).with(config, stack_name, template, stdout: stdout)
      AwsHelpers::CloudFormation.new.stack_provision(stack_name, template, stdout: stdout)
    end

    it 'should create StackProvision with optional :bucket_polling' do
      expect(AwsHelpers::Actions::CloudFormation::StackProvision).to receive(:new).with(config, stack_name, template, bucket_polling: polling)
      AwsHelpers::CloudFormation.new.stack_provision(stack_name, template, bucket_polling: polling)
    end

    it 'should create StackProvision with optional :stack_polling' do
      expect(AwsHelpers::Actions::CloudFormation::StackProvision).to receive(:new).with(config, stack_name, template, stack_polling: polling)
      AwsHelpers::CloudFormation.new.stack_provision(stack_name, template, stack_polling: polling)
    end

    it 'should call StackProvision execute method' do
      expect(stack_provision).to receive(:execute)
      AwsHelpers::CloudFormation.new.stack_provision(stack_name, template)
    end
  end

  describe '#stack_delete' do
    let(:stack_delete) { instance_double(AwsHelpers::Actions::CloudFormation::StackDelete) }
    let(:options) { {stdout: stdout, stack_polling: {delay: 1, max_attempts: 2}} }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(AwsHelpers::Actions::CloudFormation::StackDelete).to receive(:new).and_return(stack_delete)
      allow(stack_delete).to receive(:execute)
    end

    it 'should create StackDelete with stack name as argument' do
      expect(AwsHelpers::Actions::CloudFormation::StackDelete).to receive(:new).with(config, stack_name, {})
      AwsHelpers::CloudFormation.new.stack_delete(stack_name)
    end

    it 'should create StackDelete with stack options' do
      expect(AwsHelpers::Actions::CloudFormation::StackDelete).to receive(:new).with(config, stack_name, stdout: stdout, delay: 1, max_attempts: 2)
      AwsHelpers::CloudFormation.new.stack_delete(stack_name, options)
    end

    it 'should call StackDelete execute method' do
      expect(stack_delete).to receive(:execute)
      AwsHelpers::CloudFormation.new.stack_delete(stack_name)
    end
  end

  describe '#stack_exists' do
    let(:stack_exists) { instance_double(AwsHelpers::Actions::CloudFormation::StackExists) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(AwsHelpers::Actions::CloudFormation::StackExists).to receive(:new).and_return(stack_exists)
      allow(stack_exists).to receive(:execute)
    end

    after(:each) do
      AwsHelpers::CloudFormation.new.stack_exists?(stack_name)
    end

    it 'should create StackExists with correct parameters ' do
      expect(AwsHelpers::Actions::CloudFormation::StackExists).to receive(:new).with(config, stack_name)
    end

    it 'should call StackExists execute method' do
      expect(stack_exists).to receive(:execute)
    end
  end

  describe '#stack_parameters' do
    let(:stack_information) { instance_double(AwsHelpers::Actions::CloudFormation::StackInformation) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(AwsHelpers::Actions::CloudFormation::StackInformation).to receive(:new).and_return(stack_information)
      allow(stack_information).to receive(:execute)
    end

    it 'should create StackInformation using parameters info_field' do
      expect(AwsHelpers::Actions::CloudFormation::StackInformation).to receive(:new).with(config, stack_name, 'parameters')
      AwsHelpers::CloudFormation.new.stack_parameters(stack_name)
    end
  end

  describe '#stack_outputs' do
    let(:stack_information) { instance_double(AwsHelpers::Actions::CloudFormation::StackInformation) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(AwsHelpers::Actions::CloudFormation::StackInformation).to receive(:new).and_return(stack_information)
      allow(stack_information).to receive(:execute)
    end

    it 'should create StackInformation using output info_field' do
      expect(AwsHelpers::Actions::CloudFormation::StackInformation).to receive(:new).with(config, stack_name, 'outputs')
      AwsHelpers::CloudFormation.new.stack_outputs(stack_name)
    end
  end

  describe '#stack_modify_parameters' do
    let(:stack_modify_parameters) { instance_double(AwsHelpers::Actions::CloudFormation::StackModifyParameters) }
    let(:parameters) { [{parameter_key: 'key', parameter_value: 'value'}] }
    let(:options) { {stdout: stdout, stack_polling: {delay: 1, max_attempts: 2}} }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(AwsHelpers::Actions::CloudFormation::StackModifyParameters).to receive(:new).and_return(stack_modify_parameters)
      allow(stack_modify_parameters).to receive(:execute)
    end

    after(:each) do
      AwsHelpers::CloudFormation.new.stack_modify_parameters(stack_name, parameters)
    end

    it 'should create StackModifyParameters' do
      expect(AwsHelpers::Actions::CloudFormation::StackModifyParameters).to receive(:new).with(config, stack_name, parameters, {})
      AwsHelpers::CloudFormation.new.stack_modify_parameters(stack_name, parameters)
    end

    it 'should call StackModifyParameters execute method' do
      expect(stack_modify_parameters).to receive(:execute)
      AwsHelpers::CloudFormation.new.stack_modify_parameters(stack_name, parameters)
    end

    it 'should create StackModifyParameters with stack options' do
      expect(AwsHelpers::Actions::CloudFormation::StackModifyParameters).to receive(:new).with(config, stack_name, parameters, stdout: stdout, delay: 1, max_attempts: 2)
      AwsHelpers::CloudFormation.new.stack_modify_parameters(stack_name, parameters, options)
    end

  end

  describe '#stack_resources' do
    let(:stack_resources) { instance_double(AwsHelpers::Actions::CloudFormation::StackResources) }
    let(:stack_name) { 'my_stack_name' }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(AwsHelpers::Actions::CloudFormation::StackResources).to receive(:new).and_return(stack_resources)
      allow(stack_resources).to receive(:execute)
    end

    after(:each) do
      AwsHelpers::CloudFormation.new.stack_resources(stack_name)
    end

    it 'should create StackModifyParameters' do
      expect(AwsHelpers::Actions::CloudFormation::StackResources).to receive(:new).with(config, stack_name)
    end

    it 'should call StackModifyParameters execute method' do
      expect(stack_resources).to receive(:execute)
    end
  end

  describe '#stack_named_resource' do
    let(:stack_named_resource) { instance_double(AwsHelpers::Actions::CloudFormation::StackNamedResource) }
    let(:stack_name) { 'my_stack_name' }
    let(:logical_resource_id) { 'my_resource_id' }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(AwsHelpers::Actions::CloudFormation::StackNamedResource).to receive(:new).and_return(stack_named_resource)
      allow(stack_named_resource).to receive(:execute)
    end

    after(:each) do
      AwsHelpers::CloudFormation.new.stack_named_resource(stack_name, logical_resource_id)
    end

    it 'should create StackModifyParameters' do
      expect(AwsHelpers::Actions::CloudFormation::StackNamedResource).to receive(:new).with(config, stack_name, logical_resource_id)
    end

    it 'should call StackModifyParameters execute method' do
      expect(stack_named_resource).to receive(:execute)
    end
  end

end
