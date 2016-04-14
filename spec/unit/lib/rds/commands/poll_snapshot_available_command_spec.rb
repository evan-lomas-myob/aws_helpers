require 'aws_helpers/rds_commands/commands/poll_snapshot_available_command'
require 'aws_helpers/rds_commands/requests/poll_snapshot_available_request'

describe AwsHelpers::RDSCommands::Commands::PollSnapshotAvailableCommand do
  let(:image) { Aws::RDS::Types::Snapshot.new }
  let(:result) { Aws::RDS::Types::DescribeSnapshotsResult.new(images: [image]) }
  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }
  let(:request) { AwsHelpers::RDSCommands::Requests::PollSnapshotAvailableRequest.new }

  before do
    @command = AwsHelpers::RDSCommands::Commands::PollSnapshotAvailableCommand.new(config, request)
    allow(rds_client)
      .to receive(:describe_images)
      .and_return(result)
  end

  it 'polls' do
    image.state = 'available'
    expect(@command).to receive(:poll)
    @command.execute
  end

  it 'returns if the image status is available' do
    image.state = 'available'
    expect { @command.execute }.not_to raise_error
  end

  it 'raises an exception if the image status is failed' do
    image.state = 'failed'
    request.image_name = 'Batman'
    expect { @command.execute }.to raise_error(RuntimeError)
  end
end
