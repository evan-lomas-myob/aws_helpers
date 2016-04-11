require 'aws_helpers/ec2_commands/commands/image_add_user_command'
require 'aws_helpers/ec2_commands/requests/image_add_user_request'

describe AwsHelpers::EC2Commands::Commands::ImageAddUserCommand do
  let(:image_id) { '123' }
  let(:user_id) { '321' }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::ImageAddUserRequest.new }

  before do
    request.image_id = image_id
    request.user_id = user_id
    @command = AwsHelpers::EC2Commands::Commands::ImageAddUserCommand.new(config, request)
  end

  it 'calls deregister_image on the client with the specified image id' do
    expect(ec2_client)
      .to receive(:modify_image_attribute)
      .with(image_id: image_id, launch_permission: { add: [user_id: user_id]})
    @command.execute
  end
end
