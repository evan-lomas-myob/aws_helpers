require 'time'
require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/image_add_user'
require 'aws_helpers/actions/ec2/poll_image_available'

describe AwsHelpers::Actions::EC2::ImageAddUser do

  describe '#execute' do

    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
    let(:stdout) { instance_double(IO) }
    let(:image_id) { 'image_id' }
    let(:user_name) { 'user_name' }

    let(:poll_image_available) { instance_double(AwsHelpers::Actions::EC2::PollImageAvailable) }
    let(:launch_permission) { {add: [{user_id: user_name}]} }


    it 'Polls that the image is available' do
      allow(AwsHelpers::Actions::EC2::PollImageAvailable).to receive(:new).and_return(poll_image_available)
      allow(stdout).to receive(:puts).with('Sharing Image image_id with user_name')
      allow(aws_ec2_client).to receive(:modify_image_attribute)
      expect(poll_image_available).to receive(:execute)
      AwsHelpers::Actions::EC2::ImageAddUser.new(config, image_id, user_name, stdout: stdout).execute
    end

    it 'Call modify ami attribute to add the user name' do
      allow(AwsHelpers::Actions::EC2::PollImageAvailable).to receive(:new).and_return(poll_image_available)
      allow(stdout).to receive(:puts).with('Sharing Image image_id with user_name')
      allow(poll_image_available).to receive(:execute)
      expect(aws_ec2_client).to receive(:modify_image_attribute).with(image_id: 'image_id', launch_permission: launch_permission)
      AwsHelpers::Actions::EC2::ImageAddUser.new(config, image_id, user_name, stdout: stdout).execute
    end

  end


end