require 'aws_helpers/elb_commands/commands/poll_in_service_instances_command'
require 'aws_helpers/elb_commands/requests/poll_in_service_instances_request'

describe AwsHelpers::ELBCommands::Commands::PollInServiceInstancesCommand do
  let(:state) { 'InService' }
  let(:instance_state) { Aws::ElasticLoadBalancing::Types::InstanceState.new(state: state) }
  let(:result) { Aws::ElasticLoadBalancing::Types::DescribeEndPointStateOutput.new(instance_states: [instance_state]) }
  let(:elb_client) { instance_double(Aws::ElasticLoadBalancing::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_elastic_load_balancing_client: elb_client) }
  let(:request) { AwsHelpers::ELBCommands::Requests::PollInServiceInstancesRequest.new }

  before do
    request.instance_polling = { max_attempts: 2, delay: 0 }
    request.load_balancer_names = ['Jake', 'Elwood']
    @command = AwsHelpers::ELBCommands::Commands::PollInServiceInstancesCommand.new(config, request)
    allow(elb_client)
      .to receive(:describe_instance_health)
      .and_return(result)
  end

  it 'polls' do
    expect(@command).to receive(:poll).twice
    @command.execute
  end

  it 'returns if the instance status is InService' do
    expect { @command.execute }.not_to raise_error
  end

  context 'when the state is not InService' do
    let(:state) { 'failed' }
    it 'times out if the instance status is anything else' do
      expect(elb_client).to receive(:describe_instance_health).twice
      expect { @command.execute }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
    end
  end
end
