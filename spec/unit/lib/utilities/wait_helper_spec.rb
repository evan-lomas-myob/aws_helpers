require 'aws_helpers/config'
require 'aws_helpers/utilities/wait_helper'
require 'aws_helpers/actions/ec2/image_create'

include AwsHelpers::Utilities

describe WaitHelper do

  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }

  let(:instance_id) { 'my_instance_id' }

  let(:timeout) { 60 }
  let(:waiter_names) { :instance_status_ok }
  let(:params) { {} }

  let(:delay) { 1 }
  let(:max_attempts) { 60 }

  let(:response) { instance_double(Seahorse::Client::Response) }

  let(:block) { Proc.new { |_attempts, response| response } }

  let(:waiter) { instance_double(Aws::Waiters::Waiter, delay: delay, max_attempts: max_attempts) }

  before(:each) do
    allow(aws_ec2_client).to receive(:wait_until).with(waiter_names, params).and_yield(waiter)
    allow(waiter).to receive(:before_wait)
    allow(waiter).to receive(:delay).and_return(1.0)
    allow(waiter).to receive(:max_attempts=)
  end

  after(:each) do
    WaitHelper.wait(aws_ec2_client, timeout, waiter_names, params) { block }
  end

  it 'should call WaitHelper with the correct arguments' do
    expect(aws_ec2_client).to receive(:wait_until).with(waiter_names, params).and_yield(waiter)
  end

  it 'should call before_wait' do
    expect(waiter).to receive(:before_wait)
  end

  it 'should receive delay' do
    expect(waiter).to receive(:delay).and_return(1.0)
  end

  it 'should receive max_attempts' do
    expect(waiter).to receive(:max_attempts=)
  end

  it 'should do something with a block' do
    expect(block.call(1,response)).to eq(response)
  end

end