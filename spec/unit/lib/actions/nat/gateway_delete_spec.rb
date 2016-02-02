require 'aws_helpers'
require 'aws_helpers/actions/nat/gateway_delete'

include AwsHelpers::Actions::NAT

describe GatewayDelete do

  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
  let(:stdout) { instance_double(IO) }

  let(:gateway_delete) { instance_double(GatewayDelete) }
  let(:gateway_response) { instance_double(Aws::EC2::Types::CreateNatGatewayResult) }
  let(:gateway_object) { instance_double(Aws::EC2::Types::NatGateway) }
  let(:gateway_id) { 'my-gateway-id' }
  let(:subnet_id) { 'my-subnet-id' }
  let(:allocation_id) { 'my-allocation-id' }

  it 'should create a NAT gateway' do
    expect(aws_ec2_client).to receive(:delete_nat_gateway).with(nat_gateway_id: gateway_id)
    GatewayDelete.new(config, gateway_id).execute
  end


end