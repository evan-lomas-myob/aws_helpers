
require 'aws_helpers/auto_scaling_commands/commands/get_current_instances_command'
require 'aws_helpers/auto_scaling_commands/requests/get_current_instances_request'

describe AwsHelpers::AutoScalingCommands::Commands::GetCurrentInstancesCommand do
  let(:group_name) { 'Batman' }
  let(:instance_id) { '123' }
  let(:current_instances) { [Aws::EC2::Types::Instance.new(instance_id: instance_id)] }
  let(:groups) { [Aws::AutoScaling::Types::AutoScalingGroup.new(auto_scaling_group_name: group_name, instances: current_instances)] }
  let(:group_reponse) { Aws::AutoScaling::Types::AutoScalingGroupsType.new(auto_scaling_groups: groups) }
  let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_auto_scaling_client: auto_scaling_client) }
  let(:request) { AwsHelpers::AutoScalingCommands::Requests::GetCurrentInstancesRequest.new }

  before(:each) do
    # request.autoscaling_group_name = image_name
    request.current_instances = nil
    request.auto_scaling_group_name = group_name
    @command = AwsHelpers::AutoScalingCommands::Commands::GetCurrentInstancesCommand.new(config, request)
    allow(auto_scaling_client).to receive(:describe_auto_scaling_groups)
      .with(auto_scaling_group_names: [group_name])
      .and_return(group_reponse)
  end

  context 'when the auto scaling group is found' do
    it 'adds the desired capacity to the request' do
      @command.execute
      expect(request.current_instances).to eq([instance_id])
    end
  end

  context 'when the auto scaling group is not found' do
    let(:groups) { [] }
    let(:group_name) { nil }
    it 'does not add the desired capacity to the request' do
      @command.execute
      expect(request.current_instances).to be_nil
    end
  end
end
