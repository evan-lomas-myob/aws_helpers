require 'aws_helpers/rds_commands/commands/snapshot_construct_name_command'
require 'aws_helpers/rds_commands/requests/snapshot_construct_name_request'

describe AwsHelpers::RDSCommands::Commands::SnapshotConstructNameCommand do
  # let(:name) { 'Batman' }
  # let(:tag) { Aws::RDS::Types::TagDescription.new(key: 'Name', value: name) }
  # let(:tags) { Aws::RDS::Types::DescribeTagsResult.new(tags: [tag]) }
  let(:instance_id) { '123' }
  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }
  let(:request) { AwsHelpers::RDSCommands::Requests::SnapshotConstructNameRequest.new }
  let(:now) { Time.now }

  before do
    # allow(rds_client).to receive(:describe_tags).and_return(tags)
    allow(Time).to receive(:now).and_return(now)
    request.instance_id = instance_id
  end

  it 'uses the instance name' do
    request.use_name = true
    command = AwsHelpers::RDSCommands::Commands::SnapshotConstructNameCommand.new(config, request)
    expect(command.execute).to eq("#{name}-#{now.strftime('%Y-%m-%d-%H-%M')}")
  end

  it 'generates the name' do
    request.use_name = false
    command = AwsHelpers::RDSCommands::Commands::SnapshotConstructNameCommand.new(config, request)
    expect(command.execute).to eq("#{instance_id}-#{now.strftime('%Y-%m-%d-%H-%M')}")
  end
end
