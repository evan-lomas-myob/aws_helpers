require 'aws_helpers/ec2_commands/commands/get_instance_public_ip_command'
require 'aws_helpers/ec2_commands/requests/get_instance_public_ip_request'

describe AwsHelpers::EC2Commands::Commands::GetInstancePublicIpCommand do
  let(:instance_public_ip) { '123.45.67.8' }
  let(:instance_id) { '123' }
  let(:instance) { Aws::EC2::Types::Instance.new(instance_id: instance_id, public_ip_address: instance_public_ip) }
  let(:reservation) { Aws::EC2::Types::Reservation.new(instances: [instance]) }
  let(:result) { Aws::EC2::Types::DescribeInstancesResult.new(reservations: [reservation]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::GetInstancePublicIpRequest.new }

  before do
    request.instance_id = instance_id
    @command = AwsHelpers::EC2Commands::Commands::GetInstancePublicIpCommand.new(config, request)
    allow(ec2_client).to receive(:describe_instances)
      .and_return(result)
  end

  it 'calls describe images' do
    expect(ec2_client)
      .to receive(:describe_instances)
      .with(instance_ids: [instance_id])
    @command.execute
  end

  it 'sets the public ip on the request object' do
    @command.execute
    expect(request.instance_public_ip).to eq(instance_public_ip)
  end
end
