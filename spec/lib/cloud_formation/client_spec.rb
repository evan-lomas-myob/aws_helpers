require 'rspec'
require 'aws_helpers/cloud_formation/client'

describe AwsHelpers::CloudFormation::Client do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  describe '.new' do

    it "should call AwsHelpers::CloudFormation::Client's initialize method" do
      expect(AwsHelpers::CloudFormation::Client).to receive(:new).with(options).and_return(AwsHelpers::CloudFormation::Config)
      AwsHelpers::CloudFormation::Client.new(options)
    end

  end

  describe 'CloudFormation Config methods' do

    it 'should create an instance of Aws::CloudFormation::Client' do
      expect(AwsHelpers::CloudFormation::Config.new(options).aws_cloud_formation_client).to match(Aws::CloudFormation::Client)
    end

    it 'should create an instance of Aws::S3::Client' do
      expect(AwsHelpers::CloudFormation::Config.new(options).aws_s3_client).to match(Aws::S3::Client)
    end

  end

  describe 'stack client methods' do

    let(:stack_name) { 'my_stack_name' }
    let(:template) { 'my_stack_template' }
    let(:parameters) { 'my_stack_parameters' }

    let(:config) { double(aws_cloud_formation_client: double, aws_s3_client: double) }
    let(:stack_provision) { double (AwsHelpers::CloudFormation::StackProvision.new(config.aws_cloud_formation_client, config.aws_s3_client, stack_name, template, options)) }
    let(:stack_modify_parameters) { double (AwsHelpers::CloudFormation::StackModifyParameters.new(config.aws_cloud_formation_client, stack_name, parameters)) }
    let(:stack_delete) { double (AwsHelpers::CloudFormation::StackDelete.new(config.aws_cloud_formation_client, stack_name)) }
    let(:stack_exists) { double (AwsHelpers::CloudFormation::StackExists.new(config.aws_cloud_formation_client, stack_name)) }

    before(:each) do
      allow(AwsHelpers::CloudFormation::Config).to receive(:new).with(options).and_return(config)
    end

    it 'should call execute method of stack_provision' do

      allow(AwsHelpers::CloudFormation::StackProvision).to receive(:new).with(config.aws_cloud_formation_client, config.aws_s3_client, stack_name, template, options).and_return(stack_provision)
      expect(stack_provision).to receive(:execute)
      AwsHelpers::CloudFormation::Client.new(options).stack_provision(stack_name, template, options)

    end

    it 'should call execute method of stack_modify_parameters' do

      allow(AwsHelpers::CloudFormation::StackModifyParameters).to receive(:new).with(config.aws_cloud_formation_client, stack_name, parameters).and_return(stack_modify_parameters)
      expect(stack_modify_parameters).to receive(:execute)
      AwsHelpers::CloudFormation::Client.new(options).stack_modify_parameters(stack_name, parameters)

    end

    it 'should call execute method of stack_delete' do

      allow(AwsHelpers::CloudFormation::StackDelete).to receive(:new).with(config.aws_cloud_formation_client, stack_name).and_return(stack_delete)
      expect(stack_delete).to receive(:execute)
      AwsHelpers::CloudFormation::Client.new(options).stack_delete(stack_name)

    end

    context 'should call execute method of stack_information' do

        it 'should retrieve stack parameters' do

          info = 'parameters'

          stack_information =  double (AwsHelpers::CloudFormation::StackInformation.new(config.aws_cloud_formation_client, stack_name, info))

          allow(AwsHelpers::CloudFormation::StackInformation).to receive(:new).with(config.aws_cloud_formation_client, stack_name, info).and_return(stack_information)
          expect(stack_information).to receive(:execute)
          AwsHelpers::CloudFormation::Client.new(options).stack_information(stack_name, info)

        end

        it 'should retrieve stack output' do

          info = 'output'

          stack_information =  double (AwsHelpers::CloudFormation::StackInformation.new(config.aws_cloud_formation_client, stack_name, info))

          allow(AwsHelpers::CloudFormation::StackInformation).to receive(:new).with(config.aws_cloud_formation_client, stack_name, info).and_return(stack_information)
          expect(stack_information).to receive(:execute)
          AwsHelpers::CloudFormation::Client.new(options).stack_information(stack_name, info)

        end

    end

    it 'should call execute method of stack_exists?' do

      allow(AwsHelpers::CloudFormation::StackExists).to receive(:new).with(config.aws_cloud_formation_client, stack_name).and_return(stack_exists)
      expect(stack_exists).to receive(:execute)
      AwsHelpers::CloudFormation::Client.new(options).stack_exists?(stack_name)

    end

  end

end