require 'aws_helpers/ec2_commands/commands/get_vpc_id_command'
require 'aws_helpers/ec2_commands/requests/get_vpc_id_request'

describe AwsHelpers::EC2Commands::Commands::GetVpcIdCommand do
  let(:vpc_name) { 'Gotham' }
  let(:vpc_id) { '123' }
  let(:vpc) { Aws::EC2::Types::Vpc.new(vpc_id: vpc_id) }
  let(:vpcs) { Aws::EC2::Types::DescribeVpcsResult.new(vpcs: [vpc]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::GetVpcIdRequest.new }

  before do
    request.vpc_name = vpc_name
    @command = AwsHelpers::EC2Commands::Commands::GetVpcIdCommand.new(config, request)
    allow(ec2_client).to receive(:describe_vpcs)
      .with(filters: [{ name: 'tag:Name', values: [vpc_name] }])
      .and_return(vpcs)
  end

  it 'returns the vpc id' do
    @command.execute
    expect(request.vpc_id).to eq(vpc_id)
  end
end
