require 'aws_helpers/config'
require 'aws_helpers/actions/rds/snapshot_construct_name'

include AwsHelpers
include AwsHelpers::Actions::RDS

describe SnapshotConstructName do

  let(:rds_configuration) { double(region: 'my_region') }

  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:iam_client) { instance_double(Aws::IAM::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client, aws_iam_client: iam_client) }

  let(:iam_user_arn) { 'arn:aws:iam::123456789012:user' }
  let(:iam_user_id) { '123456789012' }

  let(:db_instance_identifier) { 'my_instance_id' }
  let(:db_instance_name) { 'my_db_instance_name' }

  let(:resource_name) { "arn:aws:rds:#{rds_configuration.region}:#{iam_user_id}:db:#{db_instance_identifier}" }

  let(:tags) { [double(:tag_list, key: 'Name', value: db_instance_name)] }
  let(:user_list) { [double(:user_list, arn: iam_user_arn)] }

  before(:each) do
    allow(iam_client).to receive(:config).and_return(rds_configuration)
    allow(iam_client).to receive(:list_users).and_return(user_list)
    allow(rds_client).to receive(:list_tags_for_resource).with(resource_name).and_return(tags)
  end

  after(:each) do
    SnapshotConstructName.new(config, db_instance_identifier).execute
  end

  it 'should return the region in the iam client' do
    expect(iam_client).to receive(:config).and_return(rds_configuration)
    end

  it 'should return a list of users' do
    expect(iam_client).to receive(:list_users).and_return(user_list)
  end

  it 'should call list_tags_for_resource in the rds_client' do
    expect(rds_client).to receive(:list_tags_for_resource).with(resource_name).and_return(tags)
  end

end