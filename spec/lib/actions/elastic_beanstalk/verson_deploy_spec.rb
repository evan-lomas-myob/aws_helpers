require 'aws_helpers/elastic_beanstalk'
require 'aws_helpers/actions/elastic_beanstalk/version_deploy'

include AwsHelpers
include AwsHelpers::Actions::ElasticBeanstalk

describe VersionDeploy do

  let(:application) { 'my_application' }
  let(:environment) { 'my_environment' }
  let(:version) { 'my_version' }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(aws_elastic_beanstalk_client: double, aws_s3_client: double, aws_iam_client: double) }
  let(:version_deploy) { double(VersionDeploy) }

  it '#deploy' do
    allow(Config).to receive(:new).with(options).and_return(config)
    allow(VersionDeploy).to receive(:new).with(config, application, environment, version).and_return(version_deploy)
    expect(version_deploy).to receive(:execute)
    ElasticBeanstalk.new(options).deploy(application: application, environment: environment, version: version)
  end

end