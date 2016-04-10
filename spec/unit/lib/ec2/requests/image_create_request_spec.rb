require 'aws_helpers/ec2_commands/requests/image_create_request'

describe AwsHelpers::EC2Commands::Requests::ImageCreateRequest do
  let(:request) { AwsHelpers::EC2Commands::Requests::ImageCreateRequest.new }

  it 'contains the correct attributes' do
    keys = [
      :instance_id,
      :image_id,
      :image_name,
      :use_name,
      :instance_polling,
      :stdout,
      :image_polling
    ]
    expect(request.members).to eq(keys)
  end

  it 'set correct defaults' do
    attributes = {
      instance_polling: {
        max_attempts: 60,
        delay: 30
      },
      image_polling: {
        max_attempts: 60,
        delay: 30
      }
    }
    expect(request).to have_attributes(attributes)
  end
end
