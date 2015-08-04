require 'aws_helpers/elastic_load_balancing'
require 'aws_helpers/actions/elastic_load_balancing/check_healthy_instances'

include AwsHelpers
include AwsHelpers::Actions::ElasticLoadBalancing

describe CheckHealthyInstances do

  describe '#execute' do

    let(:load_balancing_client) { instance_double(Aws::ElasticLoadBalancing::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_elastic_load_balancing_client: load_balancing_client) }

    let(:load_balancer_name) { 'name' }
    let(:instances) { double(:load_balancer_descriptions, instances: %w( '1' )) }

    before(:each) do
      allow(load_balancing_client).to receive(:describe_load_balancers).with(load_balancer_names: ['name']).and_return(instances)
    end

    it 'should not raise an error if equal to the number of instances' do
      expect { CheckHealthyInstances.new(config, load_balancer_name, 1).execute }.to_not raise_error
    end

    it 'should raise an error if not equal to the number of instances' do
      expect { CheckHealthyInstances.new(config, load_balancer_name, 2).execute }.to raise_error('Not at capacity')
    end

  end
end