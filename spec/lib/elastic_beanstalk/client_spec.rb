require 'rspec'
require 'aws_helpers/elastic_beanstalk/client'

describe AwsHelpers::ElasticBeanstalk::Client do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:elastic_beanstalk_version) { double(AwsHelpers::ElasticBeanstalk::Version) }
  let(:application) { 'my_application' }
  let(:environment) { 'my_env' }
  let(:version) { 'my_version' }

  describe '.new' do

    it "should call AwsHelpers::Common::Client's initialize method" do
      expect(AwsHelpers::Common::Client).to receive(:new).with(options).and_return(AwsHelpers::ElasticBeanstalk::Config)
      AwsHelpers::ElasticBeanstalk::Client.new(options)
    end

  end

  describe '#deploy' do

    it 'should pass options to the Aws::ElasticBeanstalk::Client' do
      elasticbeanstalk_client = double(Aws::ElasticBeanstalk::Client)
      expect(Aws::ElasticBeanstalk::Client).to receive(:new).with(hash_including(options)).and_return(elasticbeanstalk_client)
      AwsHelpers::ElasticBeanstalk::Client.new(options).deploy(application, environment, version)
    end

    it 'should call ElasticBeanstalk::Version deploy method and receive an Aws::ElasticBeanstalk::Client, Aws::S3::Client and Aws::IAM::Client' do
      allow(elastic_beanstalk_version).to receive(:deploy)
      expect(AwsHelpers::ElasticBeanstalk::Version).to receive(:new).with(be_an_instance_of(Aws::ElasticBeanstalk::Client), be_an_instance_of(Aws::S3::Client), be_an_instance_of(Aws::IAM::Client)).and_return(elastic_beanstalk_version)
      AwsHelpers::ElasticBeanstalk::Client.new(options).deploy(application, environment, version)
    end

  end

  describe '#upload' do

    it 'should call ElasticBeanstalk::Version upload method and receive an Aws::ElasticBeanstalk::Client, Aws::S3::Client and Aws::IAM::Client' do

      version_contents = 'version_content'
      zip_folder = 'zip_folder'

      allow(elastic_beanstalk_version).to receive(:upload)
      expect(AwsHelpers::ElasticBeanstalk::Version).to receive(:new).with(be_an_instance_of(Aws::ElasticBeanstalk::Client), be_an_instance_of(Aws::S3::Client), be_an_instance_of(Aws::IAM::Client)).and_return(elastic_beanstalk_version)
      AwsHelpers::ElasticBeanstalk::Client.new(options).upload(application, version, version_contents, zip_folder)
    end


  end

end