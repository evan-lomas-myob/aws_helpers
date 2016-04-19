require 'aws_helpers/nat_commands/commands/gateway_delete_command'
require 'aws_helpers/nat_commands/requests/gateway_delete_request'

describe AwsHelpers::NATCommands::Commands::GatewayDeleteCommand do
  let(:subnet_id) { '789' }
  let(:allocation_id) { '456' }
  let(:gateway_id) { '123' }
  let(:gateway) { Aws::EC2::Types::NatGateway.new(nat_gateway_id: gateway_id) }
  let(:result) { Aws::EC2::Types::DeleteNatGatewayResult.new(nat_gateway: gateway) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::NATCommands::Requests::GatewayDeleteRequest.new }

  before do
    request.subnet_id = subnet_id
    request.allocation_id = allocation_id
    @command = AwsHelpers::NATCommands::Commands::GatewayDeleteCommand.new(config, request)
  end

  it 'calls delete on the client' do
    expect(ec2_client).to receive(:delete_nat_gateway)
    @command.execute
  end
end
