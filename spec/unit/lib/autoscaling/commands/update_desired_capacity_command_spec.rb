
require 'aws_helpers/auto_scaling_commands/commands/update_desired_capacity_command'
require 'aws_helpers/auto_scaling_commands/requests/update_desired_capacity_request'

describe AwsHelpers::AutoScalingCommands::Commands::UpdateDesiredCapacityCommand do
  let(:group_name) { 'Batman' }
  let(:desired_capacity) { 13 }
  let(:groups) { [Aws::AutoScaling::Types::AutoScalingGroup.new(auto_scaling_group_name: group_name, desired_capacity: desired_capacity)] }
  let(:group_reponse) { Aws::AutoScaling::Types::AutoScalingGroupsType.new(auto_scaling_groups: groups) }
  let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_auto_scaling_client: auto_scaling_client) }
  let(:request) { AwsHelpers::AutoScalingCommands::Requests::UpdateDesiredCapacityRequest.new }

  before(:each) do
    request.auto_scaling_group_name = group_name
    request.desired_capacity = desired_capacity
    @command = AwsHelpers::AutoScalingCommands::Commands::UpdateDesiredCapacityCommand.new(config, request)
  end

  it 'calls the client with the update request' do
    expect(auto_scaling_client).to receive(:set_desired_capacity)
      .with(auto_scaling_group_name: group_name, desired_capacity: desired_capacity)
    @command.execute
  end
end
