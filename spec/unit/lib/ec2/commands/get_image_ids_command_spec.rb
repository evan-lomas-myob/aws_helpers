
describe AwsHelpers::EC2Commands::Commands::GetImageIdsCommand do
  let(:image_name) { 'Gotham' }
  let(:image_id) { '123' }
  let(:now) { Time.now }
  let(:new_image) { Aws::EC2::Types::Image.new(image_id: 1, tags: [{ key: 'Name', value: image_name }, { key: 'Date', value: now.to_s }]) }
  let(:old_image) { Aws::EC2::Types::Image.new(image_id: 2, tags: [{ key: 'Name', value: image_name }, { key: 'Date', value: (now - 24).to_s }]) }
  let(:images) { Aws::EC2::Types::DescribeImagesResult.new(images: [new_image, old_image]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::GetImageIdsRequest.new }

  before do
    request.image_name = image_name
    @command = AwsHelpers::EC2Commands::Commands::GetImageIdsCommand.new(config, request)
    allow(ec2_client).to receive(:describe_images)
      .and_return(images)
  end

  it 'filters based on the image name' do
    expect(ec2_client).to receive(:describe_images)
      .with(filters: [{ name: 'tag:Name', values: [image_name] }])
    @command.execute
  end

  it 'filters based on tags when with_tags is provided' do
    request.with_tags = { Tag: 'test' }
    expect(ec2_client).to receive(:describe_images)
      .with(filters: [{ name: 'tag:Name', values: [image_name] }, { name: 'tag:Tag', values: ['test'] }])
    @command.execute
  end

  it 'filters based on date tag when older_than is provided' do
    request.older_than = now - 1
    @command.execute
    expect(request.image_ids).to eq([1])
  end

  it 'defaults to all if older_than is not provided' do
    @command.execute
    expect(request.image_ids).to eq([1, 2])
  end
end
