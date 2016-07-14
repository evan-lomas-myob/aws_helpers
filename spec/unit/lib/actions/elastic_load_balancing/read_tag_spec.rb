require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/elastic_load_balancing/read_tag'
require 'recursive-open-struct'

describe AwsHelpers::Actions::ElasticLoadBalancing::ReadTag do
  let(:aws_elastic_load_balancing_client) { instance_double(Aws::ElasticLoadBalancing::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_elastic_load_balancing_client: aws_elastic_load_balancing_client) }
  let(:stdout) { instance_double(IO) }
  let(:load_balancer_name) { 'load_balancer' }
  let(:tag_key) { 'my_tag' }
  let(:tag_value) { 'hello_world' }
  let(:payload) {{load_balancer_names: [load_balancer_name]}}
  let(:aws_response) {RecursiveOpenStruct.new({tag_descriptions: [ { load_balancer_name: load_balancer_name,
                                                                           tags: [{key: tag_key, value: tag_value}]
                                                                         }]
                                                    },
                                                    recurse_over_arrays: true)}
  let(:empty_aws_response) {RecursiveOpenStruct.new({tag_descriptions: []}, recurse_over_arrays: true)}

  describe '#execute' do
    before(:each) do
      allow(stdout).to receive(:puts)
    end

    it 'should return empty string when the specified tag is not found' do

      expect(aws_elastic_load_balancing_client).to receive(:describe_tags)
                                                      .with(payload).and_return(aws_response)
      tag = AwsHelpers::Actions::ElasticLoadBalancing::ReadTag.new(config, load_balancer_name, 'some_tag', stdout: stdout)
                .execute
      expect(tag).to eq('')
    end

    it 'should return empty string when load balancer has no tags' do

      expect(aws_elastic_load_balancing_client).to receive(:describe_tags)
                                                       .with(payload).and_return(empty_aws_response)
      tag = AwsHelpers::Actions::ElasticLoadBalancing::ReadTag.new(config, load_balancer_name, 'some_tag', stdout: stdout)
                .execute
      expect(tag).to eq('')
    end

    it 'should find the tag key and return its value' do

      expect(aws_elastic_load_balancing_client).to receive(:describe_tags)
                                                       .with(payload).and_return(aws_response)
      tag = AwsHelpers::Actions::ElasticLoadBalancing::ReadTag.new(config, load_balancer_name, tag_key, stdout: stdout)
                .execute
      expect(tag).to eq(tag_value)
    end

  end

end
