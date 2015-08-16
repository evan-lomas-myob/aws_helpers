require 'aws_helpers/config'
require 'aws_helpers/utilities/delete_time_builder'
require 'aws_helpers/actions/ec2/images_delete'
require 'aws_helpers/actions/ec2/images_delete_by_time'

describe AwsHelpers::Actions::EC2::ImagesDelete do

  describe '#execute' do

    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
    let(:tag_name_value) { 'AppName' }

    let(:delete_time_builder) { instance_double(AwsHelpers::Utilities::DeleteTimeBuilder) }
    let(:images_delete_by_time) { instance_double(AwsHelpers::Actions::EC2::ImagesDeleteByTime) }

    let(:hours) { 1 }
    let(:days) { 2 }
    let(:months) { 3 }
    let(:years) { 5 }
    let(:delete_time) { Time.parse('01-Jan-2015') }

    before(:each){
      allow(AwsHelpers::Utilities::DeleteTimeBuilder).to receive(:new).and_return(delete_time_builder)
      allow(delete_time_builder).to receive(:build).and_return(delete_time)
      allow(AwsHelpers::Actions::EC2::ImagesDeleteByTime).to receive(:new).and_return(images_delete_by_time)
      allow(images_delete_by_time).to receive(:execute)
    }

    after(:each) {
      AwsHelpers::Actions::EC2::ImagesDelete.new(config, tag_name_value, hours: hours, days: days, months: months, years: years).execute
    }

    it 'should call DeleteTimeBuilder #build with the correct parameters' do
      expect(delete_time_builder).to receive(:build).with(hours: hours, days: days, months: months, years: years).and_return(delete_time)
    end

    it 'should create a new DeleteByTime with the correct parameters' do
      expect(AwsHelpers::Actions::EC2::ImagesDeleteByTime).to receive(:new).with(config, tag_name_value, delete_time).and_return(images_delete_by_time)
    end

    it 'should call execute on DeleteByTime' do
      expect(images_delete_by_time).to receive(:execute)
    end

  end

end