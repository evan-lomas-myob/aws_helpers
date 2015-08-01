require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/images_delete_by_time'

describe AwsHelpers::EC2Actions::ImagesDeleteByTime do

  let(:name) { 'ec2_name' }
  let(:time) { Time.local(2000,"jan",1,20,15,1) }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_ec2_client: double) }
  let(:images_delete_by_time) { double(AwsHelpers::EC2Actions::ImagesDeleteByTime) }

  it '#images_delete_by_time' do
    allow(AwsHelpers::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::EC2Actions::ImagesDeleteByTime).to receive(:new).with(config, name, time).and_return(images_delete_by_time)
    expect(images_delete_by_time).to receive(:execute)
    AwsHelpers::EC2.new(options).images_delete_by_time(name: name, time: time)
  end

end
