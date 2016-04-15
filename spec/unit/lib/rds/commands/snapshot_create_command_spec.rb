require 'aws_helpers/rds_commands/commands/snapshot_create_command'
require 'aws_helpers/rds_commands/requests/snapshot_create_request'

describe AwsHelpers::RDSCommands::Commands::SnapshotCreateCommand do
  let(:db_instance_identifier) { '123' }
  let(:snapshot_name) { 'Batman' }
  let(:db_snapshot_identifier) { '321' }
  let(:snapshot) { Aws::RDS::Types::DBSnapshot.new(db_snapshot_identifier: db_snapshot_identifier) }
  let(:result) { Aws::RDS::Types::CreateDBSnapshotResult.new(db_snapshot: snapshot) }
  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }
  let(:request) { AwsHelpers::RDSCommands::Requests::SnapshotCreateRequest.new }

  before do
    request.db_instance_identifier = db_instance_identifier
    request.snapshot_name = snapshot_name
    @command = AwsHelpers::RDSCommands::Commands::SnapshotCreateCommand.new(config, request)
    allow(rds_client)
      .to receive(:create_db_snapshot)
      .and_return(result)
  end

  it 'calls create_db_snapshot on the client with the correct parameters' do
    expect(rds_client)
      .to receive(:create_db_snapshot)
      .with(db_instance_identifier: db_instance_identifier, db_snapshot_identifier: snapshot_name)
    @command.execute
  end

  it 'adds the db_instance_id to the request' do
    @command.execute
    expect(request.db_snapshot_identifier).to eq(db_snapshot_identifier)
  end
end
