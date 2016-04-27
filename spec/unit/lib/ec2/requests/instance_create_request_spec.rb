require 'aws_helpers/ec2_commands/requests/instance_create_request'

describe AwsHelpers::EC2Commands::Requests::InstanceCreateRequest do
  let(:request) { AwsHelpers::EC2Commands::Requests::InstanceCreateRequest.new }

  it 'contains the correct attributes' do
    keys = [
      :image_id,
      :instance_id,
      :instance_polling
    ]
    expect(request.members).to match_array(keys)
  end
end
