require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/images_delete'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe ImagesDelete do

  let(:name) { 'ec2_name' }
  let(:default_days) { nil }
  let(:default_months) { nil }
  let(:default_years) { nil }

  let(:days) { 1 }
  let(:months) { 1 }
  let(:years) { 1 }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_ec2_client: double) }
  let(:images_delete) { double(ImagesDelete) }

  it '#images_delete with image name' do
    allow(Config).to receive(:new).with(options).and_return(config)
    allow(ImagesDelete).to receive(:new).with(config, name, default_days, default_months, default_years).and_return(images_delete)
    expect(images_delete).to receive(:execute)
    EC2.new(options).images_delete(name: name)
  end

  it '#images_delete with days, months and years supplied' do
    allow(Config).to receive(:new).with(options).and_return(config)
    allow(ImagesDelete).to receive(:new).with(config, name, days, months, years).and_return(images_delete)
    expect(images_delete).to receive(:execute)
    EC2.new(options).images_delete(name: name, days: days, months: months, years: years)
  end

end
