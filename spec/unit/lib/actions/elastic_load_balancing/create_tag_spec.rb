require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/elastic_load_balancing/create_tag'

describe AwsHelpers::Actions::ElasticLoadBalancing::CreateTag do
  let(:aws_elastic_load_balancing_client) { instance_double(Aws::ElasticLoadBalancing::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_elastic_load_balancing_client: aws_elastic_load_balancing_client) }
  let(:stdout) { instance_double(IO) }
  let(:load_balancer_name) { 'load_balancer' }
  let(:tag_key) { 'my_tag' }
  let(:tag_value) { 'hello_world' }
  let(:payload) {{load_balancer_names: [load_balancer_name], tags: [{key: tag_key, value: tag_value}]}}

  describe '#execute' do
    before(:each) do
      allow(stdout).to receive(:puts)
    end

    it 'should call add_tags with correct parameters on the AWS::ElasticLoadBalancing::Client' do
      expect(aws_elastic_load_balancing_client).to receive(:add_tags).with(payload).and_return([])
      AwsHelpers::Actions::ElasticLoadBalancing::CreateTag.new(config, load_balancer_name, tag_key, tag_value, stdout: stdout).execute
    end

  end

end
