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

  before(:each) do
    # allow(aws_ec2_client).to receive(:create_nat_gateway).with(subnet_id, allocation_id).and_return(gateway_response)
    # allow(gateway_response).to receive(:nat_gateway).and_return(gateway_object)
    # allow(gateway_object).to receive(:nat_gateway_id).and_return(gateway_id)
    # allow(gateway_create).to receive(:execute).and_return(gateway_id)
  end

  it 'should create a NAT gateway' do
    expect(aws_ec2_client).to receive(:delete_nat_gateway).with(gateway_id)
    GatewayDelete.new(config, gateway_id).execute
  end


end