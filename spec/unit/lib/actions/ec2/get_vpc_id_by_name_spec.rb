require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/get_vpc_id_by_name'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe GetVpcIdByName do
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }

  let(:vpc_name) { 'VPC_NAME' }
  let(:vpc_id) { 'VPC_ID' }
  let(:vpcs) { [instance_double(Aws::EC2::Types::Vpc, vpc_id: vpc_id)] }

  let(:filter_tags) { [{ name: 'tag:Name', values: [vpc_name] }] }

  let(:options) { {} }
  let(:stdout_options) { { stdout: 'file_handle' } }

  context 'VPC Name is found' do
    before(:each) do
      allow(ec2_client)
        .to receive(:describe_vpcs)
        .and_return(
          instance_double(
            Aws::EC2::Types::DescribeVpcsResult,
            vpcs: vpcs
          )
        )
    end

    it 'should call Aws::EC2::Client #describe_vpcs with filter' do
      expect(ec2_client).to receive(:describe_vpcs).with(filters: filter_tags)
      GetVpcIdByName.new(config, vpc_name, options).get_id
    end

    it 'should return vpc id matching a name' do
      expect(GetVpcIdByName.new(config, vpc_name, options).get_id).to eql(vpc_id)
    end
  end

  context 'No matching VPC Name is found' do
    it 'should return nil if no matching ID is found' do
      allow(ec2_client).to receive(:describe_vpcs).and_return(instance_double(Aws::EC2::Types::DescribeVpcsResult, vpcs: []))
      expect(GetVpcIdByName.new(config, vpc_name, options).get_id).to eql(nil)
    end
  end
end
