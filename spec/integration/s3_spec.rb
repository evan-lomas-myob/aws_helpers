require 'aws_helpers/s3'

describe AwsHelpers::S3 do

  random_string = ('a'..'z').to_a.shuffle[0,16].join

  s3_bucket_name = "new-bucket-#{random_string}"
  bucket_encrypt = true

  s3_bucket_location = 'ap-southeast-2'
  s3_bucket_url = "https://#{s3_bucket_name}.s3-#{s3_bucket_location}.amazonaws.com"

  stack_name_1 = 'my-stack-name-1'
  stack_name_2 = 'my-stack-name-2'

  template_json_1 = IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'cloudformation.template.json'))
  template_json_2 = IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'cloudformation.template.json'))

  objects = [{key: stack_name_1}, {key: stack_name_2}]


  after(:each) do
    client = Aws::S3::Client.new
    client.delete_objects(bucket: s3_bucket_name, delete: {objects: objects})
    client.delete_bucket(bucket: s3_bucket_name) # bucket will be deleted
  end

  context 'simple s3 bucket actions' do

    before(:each) do
      AwsHelpers::S3.new.s3_create(s3_bucket_name: s3_bucket_name)
    end

    describe '#stack_exists?' do

      it 'should check if the s3 exists' do
        expect(AwsHelpers::S3.new.s3_exists?(s3_bucket_name: s3_bucket_name)).to eq(true)
      end

    end

    describe '#s3_location' do

      it 'should check the s3 bucket location' do
        expect(AwsHelpers::S3.new.s3_location(s3_bucket_name: s3_bucket_name)).to eq(s3_bucket_location)
      end

    end

    describe '#s3_url' do

      it 'should return the s3 bucket url' do
        expect(AwsHelpers::S3.new.s3_url(s3_bucket_name: s3_bucket_name)).to eq(s3_bucket_url)
      end

    end

  end

  describe '#S3UploadTemplate' do

    it 'create the template and upload the stack template' do
      expect(upload_template(stack_name_1, template_json_1, s3_bucket_name, bucket_encrypt)).to eq(s3_bucket_url) #bucket will be created
      expect(upload_template(stack_name_2, template_json_2, s3_bucket_name, bucket_encrypt)).to eq(s3_bucket_url) #bucket will be updated
    end

  end

  private

  def upload_template(stack_name, template_json, s3_bucket_name, bucket_encrypt)
    AwsHelpers::S3.new.upload_stack_template(stack_name: stack_name, template_json: template_json, s3_bucket_name: s3_bucket_name, bucket_encrypt: bucket_encrypt)
  end

end
