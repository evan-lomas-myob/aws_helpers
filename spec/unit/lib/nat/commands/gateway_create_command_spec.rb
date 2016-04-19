require 'aws_helpers/nat_commands/commands/gateway_create_command'
require 'aws_helpers/nat_commands/requests/gateway_create_request'

describe AwsHelpers::NATCommands::Commands::GatewayCreateCommand do
  let(:subnet_id) { '789' }
  let(:allocation_id) { '456' }
  let(:gateway_id) { '123' }
  let(:gateway) { Aws::EC2::Types::NatGateway.new(nat_gateway_id: gateway_id) }
  let(:result) { Aws::EC2::Types::CreateNatGatewayResult.new(nat_gateway: gateway) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::NATCommands::Requests::GatewayCreateRequest.new }

  before do
    request.subnet_id = subnet_id
    request.allocation_id = allocation_id
    @command = AwsHelpers::NATCommands::Commands::GatewayCreateCommand.new(config, request)
    allow(ec2_client)
      .to receive(:create_nat_gateway)
      .and_return(result)
  end

  it 'adds the gateway_id to the request' do
    @command.execute
    expect(request.gateway_id).to eq(gateway_id)
  end
end
