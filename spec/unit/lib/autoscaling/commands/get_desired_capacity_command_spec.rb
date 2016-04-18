
require 'aws_helpers/auto_scaling_commands/commands/get_desired_capacity_command'
require 'aws_helpers/auto_scaling_commands/requests/get_desired_capacity_request'

describe AwsHelpers::AutoScalingCommands::Commands::GetDesiredCapacityCommand do
  let(:group_name) { 'Batman' }
  let(:desired_capacity) { 13 }
  let(:groups) { [Aws::AutoScaling::Types::AutoScalingGroup.new(auto_scaling_group_name: group_name, desired_capacity: desired_capacity)] }
  let(:group_reponse) { Aws::AutoScaling::Types::AutoScalingGroupsType.new(auto_scaling_groups: groups) }
  let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_auto_scaling_client: auto_scaling_client) }
  let(:request) { AwsHelpers::AutoScalingCommands::Requests::GetDesiredCapacityRequest.new }

  before(:each) do
    # request.autoscaling_group_name = image_name
    request.desired_capacity = nil
    request.auto_scaling_group_name = group_name
    @command = AwsHelpers::AutoScalingCommands::Commands::GetDesiredCapacityCommand.new(config, request)
    allow(auto_scaling_client).to receive(:describe_auto_scaling_groups)
      .with(auto_scaling_group_names: [group_name])
      .and_return(group_reponse)
  end

  context 'when the auto scaling group is found' do
    it 'adds the desired capacity to the request' do
      @command.execute
      expect(request.desired_capacity).to eq(13)
    end
  end

  context 'when the auto scaling group is not found' do
    let(:groups) { [] }
    let(:group_name) { nil }
    it 'does not add the desired capacity to the request' do
      @command.execute
      expect(request.desired_capacity).to be_nil
    end
  end
end
