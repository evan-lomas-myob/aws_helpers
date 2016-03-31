require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/get_security_group_id_by_name'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe GetSecurityGroupIdByName do
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }

  let(:sg_name) { 'GROUP_NAME' }
  let(:sg_id) { 'GROUP_ID' }
  let(:sgs) { [instance_double(Aws::EC2::Types::SecurityGroup, group_id: sg_id)] }

  let(:filter_tags) { [{ name: 'group-name', values: [sg_name] }] }

  let(:options) { {} }
  let(:stdout_options) { { stdout: 'file_handle' } }

  context 'Security Group Name is found' do
    before(:each) do
      allow(ec2_client)
        .to receive(:describe_security_groups)
        .and_return(
          instance_double(
            Aws::EC2::Types::DescribeSecurityGroupsResult,
            security_groups: sgs
          )
        )
    end

    it 'should call Aws::EC2::Client #describe_security_groups with filter' do
      expect(ec2_client).to receive(:describe_security_groups).with(filters: filter_tags)
      GetSecurityGroupIdByName.new(config, sg_name, options).id
    end

    it 'should return vpc id matching a name' do
      expect(GetSecurityGroupIdByName.new(config, sg_name, options).id).to eql(sg_id)
    end
  end

  context 'No matching VPC Name is found' do
    it 'should return nil if no matching ID is found' do
      allow(ec2_client).to receive(:describe_security_groups).and_return(instance_double(Aws::EC2::Types::DescribeSecurityGroupsResult, security_groups: []))
      expect(GetSecurityGroupIdByName.new(config, sg_name, options).id).to eql(nil)
    end
  end
end
