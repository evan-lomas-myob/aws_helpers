require 'rspec'
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
  let(:params) { double(:params, instance_id: [instance_id] ) }

  let(:block) { 'block' }

  it 'should call WaitHelper with the correct arguments' do
    expect(aws_ec2_client).to receive(:wait_until)
    WaitHelper.wait(aws_ec2_client, timeout, waiter_names, params) { block }
  end

end