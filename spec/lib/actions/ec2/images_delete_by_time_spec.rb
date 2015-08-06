require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/images_delete_by_time'

include AwsHelpers::Actions::EC2

describe ImagesDeleteByTime do

  describe '#execute' do

    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
    let(:find_by_tags) { instance_double(ImagesFindByTags) }
    let(:tag_name_value) { 'app_name' }
    let(:creation_time) { Time.parse('1-Feb-2015 00:00:00') }

    before(:each) {
      allow(ImagesFindByTags).to receive(:new).and_return(find_by_tags)
      allow(find_by_tags).to receive(:execute).and_return(images)
      allow(aws_ec2_client).to receive(:deregister_image)
    }

    after(:each) {
      ImagesDeleteByTime.new(config, tag_name_value, creation_time).execute
    }

    context 'with all images available' do

      let(:images) {
        double(images:
                   [
                       double(:first_image, image_id: 'first_image', creation_date: '1-Feb-2015 00:00:00', state: 'available'),
                       double(:second_image, image_id: 'second_image', creation_date: '1-Feb-2015 00:00:01', state: 'available')
                   ]) }

      it 'should call ImagesFindByTags.new with correct parameters' do
        expect(ImagesFindByTags).to receive(:new).with(config, {name: 'Name', value: tag_name_value}).and_return(find_by_tags)
      end

      it 'should call ImagesFindByTags execute method' do
        expect(find_by_tags).to receive(:execute).and_return(images)
      end

      it 'should delete images older than creation_time' do
        expect(aws_ec2_client).to receive(:deregister_image).with(image_id: 'first_image')
      end

    end

    context 'with deregistered images' do

      let(:images) {
        double(images:
                   [
                       double(:first_image, image_id: 'first_image', creation_date: '1-Feb-2015 00:00:00', state: 'available'),
                       double(:second_image, image_id: 'second_image', creation_date: '1-Feb-2015 00:00:00', state: 'something_else')
                   ]) }

      it 'should only delete available images' do
        expect(aws_ec2_client).to receive(:deregister_image).with(image_id: 'first_image')
      end

    end

  end

end
