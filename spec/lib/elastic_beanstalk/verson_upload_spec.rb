require 'rspec'
require 'aws_helpers/elastic_beanstalk/client'
require 'aws_helpers/elastic_beanstalk/version_upload'

describe 'AwsHelpers::ElasticBeanStalk::VersionUpload' do

  let(:upload_parameters) { 'my_upload_params' }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_elastic_beanstalk_client: double, aws_s3_client: double, aws_iam_client: double) }
  let(:version_upload) { double(AwsHelpers::ElasticBeanstalk::VersionUpload) }

  it '#deploy' do


    allow(AwsHelpers::ElasticBeanstalk::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::ElasticBeanstalk::VersionUpload).to receive(:new).with(config, upload_parameters).and_return(version_upload)
    expect(version_upload).to receive(:execute)
    AwsHelpers::ElasticBeanstalk::Client.new(options).upload(upload_parameters)

  end
end