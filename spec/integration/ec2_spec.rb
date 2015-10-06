require 'aws_helpers/ec2'

describe AwsHelpers::EC2 do

  random_string = ('a'..'z').to_a.shuffle[0, 8].join
  instance_id = nil

  let(:image_id) { 'ami-69631053' }
  let(:app_name) { "ec2-integration-test-#{random_string}" }
  let(:options) { {app_name: app_name} }

  let(:tags) { [ app_name ] }

  before(:each) do
    instance_id = AwsHelpers::EC2.new.instance_create(image_id, options)
  end

  after(:each) do
    AwsHelpers::EC2.new.instance_terminate(instance_id) if instance_id
  end

  it 'should return the instance_id of the instance created' do
    response = AwsHelpers::EC2.new.instance_find_by_tag_value(tags)
    expect(response.reservations.first.instances.first.instance_id).to eq(instance_id)
  end

  it 'should stop and start the instance' do
    AwsHelpers::EC2.new.instance_stop(instance_id, {})
    AwsHelpers::EC2.new.instance_start(instance_id, {})
  end

end
