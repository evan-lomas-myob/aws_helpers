require 'aws_helpers/ec2_commands/commands/image_construct_name_command'
require 'aws_helpers/ec2_commands/requests/image_create_request'

describe AwsHelpers::EC2Commands::Commands::ImageConstructNameCommand do
  let(:name) { 'Batman' }
  let(:tag) { Aws::EC2::Types::TagDescription.new(key: 'Name', value: name) }
  let(:tags) { Aws::EC2::Types::DescribeTagsResult.new(tags: [tag]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::ImageCreateRequest.new }
  let(:now) { Time.now }
  let(:instance_id) { 'MyID' }

  before do
    allow(ec2_client).to receive(:describe_tags).and_return(tags)
    allow(Time).to receive(:now).and_return(now)
    request.instance_id = instance_id
  end

  it 'uses the instance name' do
    request.use_name = true
    command = AwsHelpers::EC2Commands::Commands::ImageConstructNameCommand.new(config, request)
    expect(command.execute).to eq("#{name}-#{now.strftime('%Y-%m-%d-%H-%M')}")
  end

  it 'generates the name' do
    request.use_name = false
    command = AwsHelpers::EC2Commands::Commands::ImageConstructNameCommand.new(config, request)
    expect(command.execute).to eq("#{instance_id}-#{now.strftime('%Y-%m-%d-%H-%M')}")
  end
end
