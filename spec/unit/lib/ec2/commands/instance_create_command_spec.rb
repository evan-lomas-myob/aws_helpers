require 'aws_helpers/ec2_commands/commands/instance_create_command'
require 'aws_helpers/ec2_commands/requests/instance_create_request'

describe AwsHelpers::EC2Commands::Commands::InstanceCreateCommand do
  let(:instance_id) { '123' }
  let(:image_id) { '321' }
  let(:instance) { Aws::EC2::Types::Instance.new(instance_id: instance_id) }
  let(:result) { Aws::EC2::Types::Reservation.new(instances: [instance]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::InstanceCreateRequest.new }

  before do
    request.image_id = image_id
    @command = AwsHelpers::EC2Commands::Commands::InstanceCreateCommand.new(config, request)
    allow(ec2_client)
      .to receive(:run_instances)
      .and_return(result)
  end

  it 'calls run_instances on the client with the correct parameters' do
    expect(ec2_client)
      .to receive(:run_instances)
      .with(image_id: image_id, min_count: 1, max_count: 1, user_data: '', instance_type: 't2.micro')
    @command.execute
  end

  it 'sets the instance type if provided' do
    request.instance_type = 'm4.10xlarge'
    expect(ec2_client)
      .to receive(:run_instances)
      .with(image_id: image_id, min_count: 1, max_count: 1, user_data: '', instance_type: 'm4.10xlarge')
    @command.execute
  end

  it 'sets the user data for the instance if provided' do
    request.user_data = 'The Caped Crusader'
    expect(ec2_client)
      .to receive(:run_instances)
      .with(image_id: image_id, min_count: 1, max_count: 1, user_data: Base64.encode64('The Caped Crusader'), instance_type: 't2.micro')
    @command.execute
  end

  it 'adds the instance_id to the request' do
    @command.execute
    expect(request.instance_id).to eq(instance_id)
  end
end
