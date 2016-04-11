require 'aws_helpers/ec2_commands/commands/poll_instance_healthy_command'
require 'aws_helpers/ec2_commands/requests/image_create_request'

describe AwsHelpers::EC2Commands::Commands::PollInstanceHealthyCommand do
  let(:status_summary) { Aws::EC2::Types::InstanceStatusSummary.new }
  let(:instance_status) { Aws::EC2::Types::InstanceStatus.new(instance_status: status_summary) }
  let(:result) { Aws::EC2::Types::DescribeInstanceStatusResult.new(instance_statuses: [instance_status]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::InstanceCreateRequest.new }

  before do
    request.instance_polling = { delay: 0, max_attempts: 5 }
    @command = AwsHelpers::EC2Commands::Commands::PollInstanceHealthyCommand.new(config, request)
    allow(ec2_client)
      .to receive(:describe_instance_status)
      .and_return(result)
  end

  it 'polls' do
    status_summary.status = 'ok'
    expect(@command).to receive(:poll)
    @command.execute
  end

  it 'returns if the instance status is ok' do
    status_summary.status = 'ok'
    expect { @command.execute }.not_to raise_error
  end

  it 'times out and raises an exception if the instance status is anything else' do
    status_summary.status = 'riddler'
    expect(ec2_client).to receive(:describe_instance_status).exactly(5).times
    expect { @command.execute }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
  end
end
