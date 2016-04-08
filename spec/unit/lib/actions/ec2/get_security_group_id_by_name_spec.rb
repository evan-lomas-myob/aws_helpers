require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/get_security_group_id_by_name'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe GetSecurityGroupIdByName do
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }

  let(:sg_name) { 'GROUP_NAME' }
  let(:sg_id) { 'GROUP_ID' }

  let(:filter_tags) { [{ name: 'group-name', values: [sg_name] }] }

  before(:each) do
    allow(ec2_client)
      .to receive(:describe_security_groups)
      .and_return(Aws::EC2::Types::DescribeSecurityGroupsResult.new(security_groups: returned_groups))
  end

  context 'Security Group exists' do
    let(:returned_groups) { [Aws::EC2::Types::SecurityGroup.new(group_id: sg_id)] }

    it 'should call Aws::EC2::Client #describe_security_groups with filter' do
      expect(ec2_client).to receive(:describe_security_groups).with(filters: filter_tags)
      GetSecurityGroupIdByName.new(config, sg_name).id
    end

    it 'should return vpc id matching a name' do
      expect(GetSecurityGroupIdByName.new(config, sg_name).id).to eql(sg_id)
    end
  end

  context 'Security Group does not exist' do
    let(:returned_groups) { [] }

    it 'should return nil' do
      expect(GetSecurityGroupIdByName.new(config, sg_name).id).to eql(nil)
    end
  end
end
