require 'aws_helpers/ec2_commands/commands/get_security_group_id_command'
require 'aws_helpers/ec2_commands/requests/get_security_group_id_request'

describe AwsHelpers::EC2Commands::Commands::GetSecurityGroupIdCommand do
  let(:security_group_name) { 'Gotham' }
  let(:security_group_id) { '123' }
  let(:security_group) { Aws::EC2::Types::SecurityGroup.new(group_id: security_group_id) }
  let(:security_groups) { Aws::EC2::Types::DescribeSecurityGroupsResult.new(security_groups: [security_group]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::GetSecurityGroupIdRequest.new }

  before do
    request.security_group_name = security_group_name
    @command = AwsHelpers::EC2Commands::Commands::GetSecurityGroupIdCommand.new(config, request)
    allow(ec2_client).to receive(:describe_security_groups)
      .with(filters: [{ name: 'tag:Name', values: [security_group_name] }])
      .and_return(security_groups)
  end

  it 'returns the security_group id' do
    @command.execute
    expect(request.security_group_id).to eq(security_group_id)
  end
end
