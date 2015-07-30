require 'rspec'
require 'aws_helpers/ec2/client'
require 'aws_helpers/ec2/images_delete_by_time'

describe 'AwsHelpers::EC2::ImagesDeleteByTime' do

  let(:name) { 'ec2_name' }
  let(:time) { Time.local(2000,"jan",1,20,15,1) }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_ec2_client: double) }
  let(:images_delete_by_time) { double(AwsHelpers::EC2::ImagesDeleteByTime) }

  it '#images_delete_by_time' do
    allow(AwsHelpers::EC2::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::EC2::ImagesDeleteByTime).to receive(:new).with(config, name, time).and_return(images_delete_by_time)
    expect(images_delete_by_time).to receive(:execute)
    AwsHelpers::EC2::Client.new(options).images_delete_by_time(name, time)
  end

end
