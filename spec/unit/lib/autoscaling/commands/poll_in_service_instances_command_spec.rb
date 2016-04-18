
require 'aws_helpers/auto_scaling_commands/commands/poll_in_service_instances_command'
require 'aws_helpers/auto_scaling_commands/requests/poll_in_service_instances_request'

describe AwsHelpers::AutoScalingCommands::Commands::PollInServiceInstancesCommand do
  let(:group_name) { 'Batman' }
  let(:instance_id) { '123' }
  let(:state) { 'InService' }
  let(:current_instances) { [Aws::AutoScaling::Types::Instance.new(instance_id: instance_id, lifecycle_state: state)] }
  let(:groups) { [Aws::AutoScaling::Types::AutoScalingGroup.new(auto_scaling_group_name: group_name, instances: current_instances, desired_capacity: 1)] }
  let(:group_reponse) { Aws::AutoScaling::Types::AutoScalingGroupsType.new(auto_scaling_groups: groups) }
  let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_auto_scaling_client: auto_scaling_client) }
  let(:request) { AwsHelpers::AutoScalingCommands::Requests::PollInServiceInstancesRequest.new }

  before(:each) do
    # request.autoscaling_group_name = image_name
    request.instance_polling = { max_attempts: 2, delay: 0 }
    request.current_instances = nil
    request.auto_scaling_group_name = group_name
    @command = AwsHelpers::AutoScalingCommands::Commands::PollInServiceInstancesCommand.new(config, request)
    allow(auto_scaling_client).to receive(:describe_auto_scaling_groups)
      .with(auto_scaling_group_names: [group_name])
      .and_return(group_reponse)
  end

  it 'polls' do
    expect(@command).to receive(:poll)
    @command.execute
  end

  context 'when the desired capacity is reached' do
    it 'returns' do
      expect { @command.execute }.not_to raise_error
    end
  end

  context 'when the desired capacity is never reached' do
    let(:state) { 'Dead' }
    it 'errors after the maximum retries' do
      expect(auto_scaling_client).to receive(:describe_auto_scaling_groups).twice
      expect { @command.execute }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
    end
  end
end
