require 'aws_helpers/ec2'
require 'aws_helpers/utilities/subtract_time'
require 'aws_helpers/actions/ec2/images_delete'
require 'aws_helpers/actions/ec2/images_delete_by_time'

include AwsHelpers
include AwsHelpers::Utilities
include AwsHelpers::Actions::EC2

describe ImagesDelete do

  describe '#execute' do

    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
    let(:tag_name_value) { 'AppName' }

    let(:subtract_time) { instance_double(SubtractTime) }
    let(:images_delete_by_time) { instance_double(ImagesDeleteByTime) }

    let(:hours) { 1 }
    let(:days) { 2 }
    let(:months) { 3 }
    let(:years) { 5 }
    let(:creation_time) { Time.parse('01-Jan-2015') }

    before(:each){
      allow(SubtractTime).to receive(:new).and_return(subtract_time)
      allow(subtract_time).to receive(:execute).and_return(creation_time)
      allow(ImagesDeleteByTime).to receive(:new).and_return(images_delete_by_time)
      allow(images_delete_by_time).to receive(:execute)
    }

    after(:each) {
      ImagesDelete.new(config, tag_name_value, hours, days, months, years).execute
    }

    it 'should create a new SubtractTime with the correct parameters' do
      expect(SubtractTime).to receive(:new).with(hours: hours, days: days, months: months, years: years).and_return(subtract_time)
    end

    it 'should call execute on Subtract Time' do
      expect(subtract_time).to receive(:execute).and_return(creation_time)
    end

    it 'should create a new DeleteByTime with the correct parameters' do
      expect(ImagesDeleteByTime).to receive(:new).with(config, tag_name_value, creation_time).and_return(images_delete_by_time)
    end

    it 'should call execute on DeleteByTime' do
      expect(images_delete_by_time).to receive(:execute)
    end

  end

end