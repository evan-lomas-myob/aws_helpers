require 'aws_helpers/config'
require 'aws_helpers/actions/rds/snapshot_construct_name'

include AwsHelpers
include AwsHelpers::Actions::RDS

describe SnapshotConstructName do

  let(:rds_configuration) { double(:configuration, region: 'my_region') }
  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:iam_client) { instance_double(Aws::IAM::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client, aws_iam_client: iam_client) }

  let(:iam_user_id) { '123456789012' }
  let(:iam_user_arn) { "arn:aws:iam::#{iam_user_id}:user" }
  let(:db_instance_identifier) { 'db_instance_identifier' }
  let(:db_instance_name) { 'instance_name' }
  let(:resource_name) { "arn:aws:rds:#{rds_configuration.region}:#{iam_user_id}:db:#{db_instance_identifier}" }
  let(:list_users_response) {
    Aws::IAM::Types::ListUsersResponse.new(
      users: [
        Aws::IAM::Types::User.new(arn: iam_user_arn)
      ]
    )
  }
  let(:tag_list_response) {
    Aws::RDS::Types::TagListMessage.new(
      tag_list: [
        Aws::RDS::Types::Tag.new(key: 'Name', value: db_instance_name)
      ]

    )
  }

  before(:each) do
    allow(iam_client).to receive(:config).and_return(rds_configuration)
    allow(iam_client).to receive(:list_users).and_return(list_users_response)
    allow(rds_client).to receive(:list_tags_for_resource).and_return(tag_list_response)
  end

  describe '#execute' do

    it 'should return the name consisting of instance identifier and date correctly' do
      expect(SnapshotConstructName.new(config, db_instance_identifier, now: Time.parse('1 Feb 2015 03:04:05')).execute)
        .to eql("#{db_instance_identifier}-2015-02-01-03-04")
    end

    context 'with optional parameter user_name: set to true' do

      it 'should return the region in the iam client' do
        expect(iam_client).to receive(:config)
        SnapshotConstructName.new(config, db_instance_identifier, use_name: true).execute
      end

      it 'should return a list of users' do
        expect(iam_client).to receive(:list_users)
        SnapshotConstructName.new(config, db_instance_identifier, use_name: true).execute
      end

      it 'should call list_tags_for_resource in the rds_client' do
        expect(rds_client).to receive(:list_tags_for_resource).with(resource_name: resource_name)
        SnapshotConstructName.new(config, db_instance_identifier, use_name: true).execute
      end

      it 'should return the name consisting of instance name and date correctly' do
        expect(SnapshotConstructName.new(config, db_instance_identifier, use_name: true, now: Time.parse('1 Feb 2015 03:04:05')).execute)
          .to eql("#{db_instance_name}-2015-02-01-03-04")
      end

    end

  end


end