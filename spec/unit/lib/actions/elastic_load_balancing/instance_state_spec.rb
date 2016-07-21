require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/elastic_load_balancing/instance_state'

describe AwsHelpers::Actions::ElasticLoadBalancing::InstanceState do
  let(:in_service) { 'InService' }
  let(:out_of_service) { 'OutOfService' }
  let(:unknown) { 'Unknown' }

  describe '#execute' do
    it 'should have the right instance state constant values' do
      expect(AwsHelpers::Actions::ElasticLoadBalancing::InstanceState::IN_SERVICE).to eq(in_service)
      expect(AwsHelpers::Actions::ElasticLoadBalancing::InstanceState::OUT_OF_SERVICE).to eq(out_of_service)
      expect(AwsHelpers::Actions::ElasticLoadBalancing::InstanceState::UNKNOWN).to eq(unknown)
    end

  end

end
