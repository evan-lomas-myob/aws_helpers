require 'aws_helpers/elastic_beanstalk'

describe AwsHelpers::ElasticBeanstalk do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(AwsHelpers::Config) }

  describe '#initialize' do

    it 'should call AwsHelpers::Client initialize method' do
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::ElasticBeanstalk.new(options)
    end

  end

  describe '#deploy' do

    let(:deploy) { double(VersionDeploy) }

    let(:application) { 'my_application' }
    let(:environment) { 'my_env' }
    let(:version) { 'my_version' }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(VersionDeploy).to receive(:new).with(anything, anything, anything, anything).and_return(deploy)
      allow(deploy).to receive(:execute)
    end

    subject { AwsHelpers::ElasticBeanstalk.new(options).deploy(application: application, environment: environment, version: version) }

    it 'should create VersionDeploy' do
      expect(VersionDeploy).to receive(:new).with(config, application, environment, version)
      subject
    end

    it 'should call VersionDeploy execute method' do
      expect(deploy).to receive(:execute)
      subject
    end

  end

  describe '#version_upload' do

    let(:upload) { double(VersionUpload) }

    let(:upload_parameters) { 'my_upload_params' }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(VersionUpload).to receive(:new).with(anything, anything).and_return(upload)
      allow(upload).to receive(:execute)
    end

    subject { AwsHelpers::ElasticBeanstalk.new(options).upload(upload_parameters: upload_parameters) }

    it 'should create VersionDeploy' do
      expect(VersionUpload).to receive(:new).with(config, upload_parameters)
      subject
    end

    it 'should call VersionDeploy execute method' do
      expect(upload).to receive(:execute)
      subject
    end

  end

end