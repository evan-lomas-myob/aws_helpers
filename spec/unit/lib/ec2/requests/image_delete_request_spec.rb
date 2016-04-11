require 'aws_helpers/ec2_commands/requests/image_delete_request'

describe AwsHelpers::EC2Commands::Requests::ImageDeleteRequest do
  let(:request) { AwsHelpers::EC2Commands::Requests::ImageDeleteRequest.new }

  it 'contains the correct attributes' do
    keys = [
      :snapshot_ids,
      :image_id,
      :stdout,
      :image_polling
    ]
    expect(request.members).to match_array(keys)
  end

  it 'set correct defaults' do
    attributes = {
      image_polling: {
        max_attempts: 2,
        delay: 30
      }
    }
    expect(request).to have_attributes(attributes)
  end
end
