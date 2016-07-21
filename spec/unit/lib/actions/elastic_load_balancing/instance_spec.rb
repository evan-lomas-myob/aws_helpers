require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/elastic_load_balancing/instance'
require 'recursive-open-struct'

describe AwsHelpers::Actions::ElasticLoadBalancing::Instance do
  let(:aws_elastic_load_balancing_client) { instance_double(Aws::ElasticLoadBalancing::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_elastic_load_balancing_client: aws_elastic_load_balancing_client) }
  let(:stdout) { instance_double(IO) }
  let(:load_balancer_name) { 'load_balancer' }
  let(:instance_id) { 'i-1234' }
  let(:payload) {{load_balancer_names: [load_balancer_name]}}

  describe '#execute' do
    before(:each) do
      allow(stdout).to receive(:puts)
    end

    it 'should return empty array when load balancer is not found' do

      expect(aws_elastic_load_balancing_client).to receive(:describe_load_balancers)
                                                      .with(payload).and_return(create_response([]))
      instances = AwsHelpers::Actions::ElasticLoadBalancing::Instance.new(config, load_balancer_name, stdout: stdout)
                .execute
      expect(instances).to eq([])
    end

    it 'should the instances associated with the elb' do

      expect(aws_elastic_load_balancing_client).to receive(:describe_load_balancers)
                                                       .with(payload).and_return(create_response([{instances: [{"instance_id": instance_id}]}]))
      instances = AwsHelpers::Actions::ElasticLoadBalancing::Instance.new(config, load_balancer_name, stdout: stdout)
                .execute
      expect(instances.empty?).to eq(false)
      expect(instances.first.instance_id).to eq(instance_id)
    end

    def create_response(instances)
      #{ instances: []}
      RecursiveOpenStruct.new({load_balancer_descriptions: instances
                              },
                              recurse_over_arrays: true)
    end

  end

end
