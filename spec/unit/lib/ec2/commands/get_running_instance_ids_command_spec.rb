require 'aws_helpers/ec2_commands/commands/get_running_instance_ids_command'
require 'aws_helpers/ec2_commands/requests/get_running_instance_ids_request'

describe AwsHelpers::EC2Commands::Commands::GetRunningInstanceIdsCommand do
  let(:instance_name) { 'Gotham' }
  let(:instance_id_a) { '123' }
  let(:instance_id_b) { '546' }
  let(:instance_id_c) { '789' }
  let(:running_state) { Aws::EC2::Types::InstanceState.new(name: 'running') }
  let(:stopped_state) { Aws::EC2::Types::InstanceState.new(name: 'stopped') }
  let(:instance_a) { Aws::EC2::Types::Instance.new(instance_id: instance_id_a, state: running_state) }
  let(:instance_b) { Aws::EC2::Types::Instance.new(instance_id: instance_id_b, state: stopped_state) }
  let(:instance_c) { Aws::EC2::Types::Instance.new(instance_id: instance_id_c, state: running_state) }
  let(:reservation) { Aws::EC2::Types::Reservation.new(instances: [instance_a, instance_b, instance_c]) }
  let(:response) { Aws::EC2::Types::DescribeInstancesResult.new(reservations: [reservation]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::GetRunningInstanceIdsRequest.new }

  before do
    request.instance_ids = [instance_id_a, instance_id_b, instance_id_c]
    @command = AwsHelpers::EC2Commands::Commands::GetRunningInstanceIdsCommand.new(config, request)
    allow(ec2_client).to receive(:describe_instances)
      .with(instance_ids: [instance_id_a, instance_id_b, instance_id_c])
      .and_return(response)
  end

  it 'returns the ids of running instances' do
    @command.execute
    expect(request.running_instance_ids).to eq([instance_id_a, instance_id_c])
  end
end
