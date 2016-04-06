require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/get_vpc_id_by_name'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe GetVpcIdByName do
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }

  let(:vpc_name) { 'VPC_NAME' }
  let(:vpc_id) { 'VPC_ID' }

  let(:filter_tags) { [{ name: 'tag:Name', values: [vpc_name] }] }

  before(:each) do
    allow(ec2_client)
      .to receive(:describe_vpcs)
      .and_return(Aws::EC2::Types::DescribeVpcsResult.new(vpcs: returned_vpcs))
  end

  context 'VPC exists' do
    let(:returned_vpcs) { [Aws::EC2::Types::Vpc.new(vpc_id: vpc_id)] }

    it 'should call Aws::EC2::Client #describe_vpcs with filter' do
      expect(ec2_client).to receive(:describe_vpcs).with(filters: filter_tags)
      GetVpcIdByName.new(config, vpc_name).id
    end

    it 'should return vpc id matching a name' do
      expect(GetVpcIdByName.new(config, vpc_name).id).to eql(vpc_id)
    end
  end

  context 'VPC does not exist' do
    let(:returned_vpcs) { [] }

    it 'should return nil' do
      expect(GetVpcIdByName.new(config, vpc_name).id).to eql(nil)
    end
  end
end
