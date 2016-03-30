require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/elastic_load_balancing/poll_in_service_instances'

describe AwsHelpers::Actions::ElasticLoadBalancing::PollInServiceInstances do
  let(:aws_elastic_load_balancing_client) { instance_double(Aws::ElasticLoadBalancing::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_elastic_load_balancing_client: aws_elastic_load_balancing_client) }
  let(:stdout) { instance_double(IO) }
  let(:load_balancer_name) { 'load_balancer' }

  describe '#execute' do
    before(:each) do
      allow(stdout).to receive(:puts)
    end

    it 'should call describe_instance_health with correct parameters on the AWS::ElasticLoadBalancing::Client' do
      response = create_response
      expect(aws_elastic_load_balancing_client).to receive(:describe_instance_health).with(load_balancer_name: load_balancer_name).and_return(response)
      AwsHelpers::Actions::ElasticLoadBalancing::PollInServiceInstances.new(config, [load_balancer_name], stdout: stdout, max_attempts: 1, delay: 0).execute
    end

    it 'should write to stdout the load balancer name' do
      response = create_response
      allow(aws_elastic_load_balancing_client).to receive(:describe_instance_health).and_return(response)
      expect(stdout).to receive(:puts).with("Load Balancer Name=#{load_balancer_name}")
      AwsHelpers::Actions::ElasticLoadBalancing::PollInServiceInstances.new(config, [load_balancer_name], stdout: stdout, max_attempts: 1, delay: 0).execute
    end

    it 'should write to stdout the number of servers in various states' do
      first_response = create_response('InService', 'Unknown', 'OutOfService')
      second_response = create_response
      allow(aws_elastic_load_balancing_client).to receive(:describe_instance_health).and_return(first_response, second_response)
      expect(stdout).to receive(:puts).with("Load Balancer Name=#{load_balancer_name}, InService=1, OutOfService=1, Unknown=1")
      AwsHelpers::Actions::ElasticLoadBalancing::PollInServiceInstances.new(config, [load_balancer_name], stdout: stdout, max_attempts: 2, delay: 0).execute
    end

    it 'should poll till all instances are in service' do
      first_response = create_response('OutOfService')
      second_response = create_response('InService')
      allow(aws_elastic_load_balancing_client).to receive(:describe_instance_health).and_return(first_response, second_response)
      AwsHelpers::Actions::ElasticLoadBalancing::PollInServiceInstances.new(config, [load_balancer_name], stdout: stdout, max_attempts: 2, delay: 0).execute
    end

    it 'should raise an error if all servers are not in service after max_attempts are exceeded' do
      first_response = create_response('OutOfService')
      allow(aws_elastic_load_balancing_client).to receive(:describe_instance_health).and_return(first_response)
      expect { AwsHelpers::Actions::ElasticLoadBalancing::PollInServiceInstances.new(config, [load_balancer_name], stdout: stdout, max_attempts: 1, delay: 0).execute }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
    end
  end

  def create_response(*states)
    Aws::ElasticLoadBalancing::Types::DescribeEndPointStateOutput.new(
      instance_states: states.map { |state|
        Aws::ElasticLoadBalancing::Types::InstanceState.new(state: state)
      }
    )
  end
end
