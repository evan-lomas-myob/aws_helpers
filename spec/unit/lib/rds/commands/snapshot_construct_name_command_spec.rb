require 'aws_helpers/rds_commands/commands/snapshot_construct_name_command'
require 'aws_helpers/rds_commands/requests/snapshot_construct_name_request'

describe AwsHelpers::RDSCommands::Commands::SnapshotConstructNameCommand do
  let(:iam_user_arn) { 'arn:aws:iam::123456789012:user' }
  let(:arn) { "arn:aws:iam::#{iam_user_arn}:user" }
  let(:user) { Aws::IAM::Types::User.new(arn: arn) }
  let(:users) { Aws::IAM::Types::ListUsersResponse.new(users: [user]) }
  let(:name) { 'Batman' }
  let(:tag) { Aws::RDS::Types::Tag.new(key: 'Name', value: name) }
  let(:tags) { Aws::RDS::Types::TagListMessage.new(tag_list: [tag]) }
  let(:region) { 'ap-southeast-2' }
  let(:db_instance_id) { '123' }
  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client, aws_iam_client: iam_client) }
  let(:request) { AwsHelpers::RDSCommands::Requests::SnapshotConstructNameRequest.new }
  let(:now) { Time.now }
  let(:iam_client) { double(Aws::IAM::Client, config: double('config', region: region)) }
  

  before do
    @command = AwsHelpers::RDSCommands::Commands::SnapshotConstructNameCommand.new(config, request)
    allow(iam_client)
      .to receive(:list_users)
      .and_return(users)
    allow(rds_client)
      .to receive(:list_tags_for_resource)
      .with(resource_name: "arn:aws:rds:#{region}:#{iam_user_arn}:db:#{db_instance_id}")
      .and_return(tags)
    allow(Time).to receive(:now).and_return(now)
    request.db_instance_id = db_instance_id
  end

  it 'uses the instance name' do
    request.use_name = true
    expect(@command.execute).to eq("#{name}-#{now.strftime('%Y-%m-%d-%H-%M')}")
  end

  it 'generates the name' do
    request.use_name = false
    # command = AwsHelpers::RDSCommands::Commands::SnapshotConstructNameCommand.new(config, request)
    expect(@command.execute).to eq("#{db_instance_id}-#{now.strftime('%Y-%m-%d-%H-%M')}")
  end
end
