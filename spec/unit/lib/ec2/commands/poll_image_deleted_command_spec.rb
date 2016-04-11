require 'aws_helpers/ec2_commands/commands/poll_image_deleted_command'
require 'aws_helpers/ec2_commands/requests/image_delete_request'

describe AwsHelpers::EC2Commands::Commands::PollImageDeletedCommand do
  let(:result) { Aws::EC2::Types::DescribeImagesResult.new(images: images) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::ImageDeleteRequest.new }

  before do
    request.image_polling = { max_attempts: 2, delay: 0 }
    @command = AwsHelpers::EC2Commands::Commands::PollImageDeletedCommand.new(config, request)
    allow(ec2_client)
      .to receive(:describe_images)
      .and_return(result)
  end

  context 'when the image is deleted' do
    let(:images) { [] }

    it 'polls' do
      expect(@command).to receive(:poll)
      expect(ec2_client).not_to receive(:describe_images)
      @command.execute
    end
  end

  context 'when the image is not deleted' do
    let(:images) { [Aws::EC2::Types::Image.new] }
    it 'errors after the maximum retries' do
      expect(ec2_client).to receive(:describe_images).twice
      expect { @command.execute }.to raise_error
    end
  end
end
