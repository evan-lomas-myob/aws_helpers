require 'rspec'
require 'aws_helpers/ec2/client'
require 'aws_helpers/ec2/image'

describe AwsHelpers::EC2::Client do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  describe '.new' do

    it "should call AwsHelpers::Common::Client's initialize method" do
      expect(AwsHelpers::EC2::Client).to receive(:new).with(options).and_return(AwsHelpers::EC2::Config)
      AwsHelpers::EC2::Client.new(options)
    end

  end

  let(:ec2_client_image) { double(AwsHelpers::EC2::Image) }
  let(:name) { 'ec2_name' }

  describe '#image_create' do

    let(:ec2_client) { double(Aws::EC2::Client) }

    let(:instance_id) { 'ec2_id' }

    it 'should pass options to the Aws::EC2::Client' do

      expect(Aws::EC2::Client).to receive(:new).with(hash_including(options)).and_return(ec2_client)
      AwsHelpers::EC2::Client.new(options).image_create(name, instance_id, additional_tags = [])

    end

    it 'should call EC2::Client create method and receive an Aws::EC2::Client' do
      allow(ec2_client_image).to receive(:create)
      expect(AwsHelpers::EC2::Image).to receive(:new).with(be_an_instance_of(Aws::EC2::Client)).and_return(ec2_client_image)
      AwsHelpers::EC2::Client.new(options).image_create(name, instance_id, additional_tags = [])
    end

  end

  describe '#images_delete' do

    it 'should call EC2::Client images_delete method and receive an Aws::EC2::Client' do
      allow(ec2_client_image).to receive(:delete)
      expect(AwsHelpers::EC2::Image).to receive(:new).with(be_an_instance_of(Aws::EC2::Client)).and_return(ec2_client_image)
      AwsHelpers::EC2::Client.new(options).images_delete(name, options = [])
    end
  end

  describe '#image_delete_by_time' do

    it 'should call EC2::Client images_delete_by_time method and receive an Aws::EC2::Client' do
      allow(ec2_client_image).to receive(:delete_by_time)
      expect(AwsHelpers::EC2::Image).to receive(:new).with(be_an_instance_of(Aws::EC2::Client)).and_return(ec2_client_image)
      AwsHelpers::EC2::Client.new(options).images_delete_by_time(name, anything)
    end
  end

  describe '#image_find_by_tags' do

    it 'should call EC2::Client images_find_by_tags method and receive an Aws::EC2::Client' do
      allow(ec2_client_image).to receive(:find_by_tag)
      expect(AwsHelpers::EC2::Image).to receive(:new).with(be_an_instance_of(Aws::EC2::Client)).and_return(ec2_client_image)
      AwsHelpers::EC2::Client.new(options).images_find_by_tags(anything)
    end
  end

end
