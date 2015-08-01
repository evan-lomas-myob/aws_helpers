require 'aws_helpers/elastic_beanstalk'
require 'aws_helpers/actions/elastic_beanstalk/version_upload'

include AwsHelpers
include AwsHelpers::Actions::ElasticBeanstalk

describe VersionUpload do

  let(:upload_parameters) { 'my_upload_params' }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(aws_elastic_beanstalk_client: double, aws_s3_client: double, aws_iam_client: double) }
  let(:version_upload) { double(VersionUpload) }

  it '#deploy' do
    allow(Config).to receive(:new).with(options).and_return(config)
    allow(VersionUpload).to receive(:new).with(config, upload_parameters).and_return(version_upload)
    expect(version_upload).to receive(:execute)
    ElasticBeanstalk.new(options).upload(upload_parameters: upload_parameters)
  end
end