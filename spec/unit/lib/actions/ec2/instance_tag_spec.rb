require 'aws_helpers'
require 'aws_helpers/actions/ec2/instance_tag'

include AwsHelpers::Actions::EC2

describe EC2InstanceTag do
  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
  let(:stdout) { instance_double(IO) }
  let(:now) { Time.parse('2015 Jan 1 00:00:00') }

  let(:instance_id) { 'my-instance-id' }
  let(:app_name) { 'my-app-name' }
  let(:build_number) { 'build12345' }

  let(:tag_default) do
    {
      resources: [instance_id],
      tags: [
        { key: 'Name', value: 'no-name-supplied' },
        { key: 'Date', value: now.to_s }
      ]
    }
  end

  let(:tag_with_app) do
    {
      resources: [instance_id],
      tags: [
        { key: 'Name', value: app_name },
        { key: 'Date', value: now.to_s }
      ]
    }
  end

  let(:tag_with_build) do
    {
      resources: [instance_id],
      tags: [
        { key: 'Name', value: 'no-name-supplied' },
        { key: 'Build Number', value: build_number },
        { key: 'Date', value: now.to_s }
      ]
    }
  end

  it 'should create a standard tag if build_number is not defined' do
    expect(aws_ec2_client).to receive(:create_tags).with(tag_default)
    EC2InstanceTag.new(config, instance_id, nil, nil, now).execute
  end

  it 'should create a standard tag if build_number is not defined' do
    expect(aws_ec2_client).to receive(:create_tags).with(tag_with_app)
    EC2InstanceTag.new(config, instance_id, app_name, nil, now).execute
  end

  it 'should create a standard tag if build_number is not defined' do
    expect(aws_ec2_client).to receive(:create_tags).with(tag_with_build)
    EC2InstanceTag.new(config, instance_id, nil, build_number, now).execute
  end
end
