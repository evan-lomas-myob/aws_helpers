require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers'

describe AwsHelpers::Actions::S3::S3UploadTemplate do

  # def initialize(config, stack_name, template_json, s3_bucket_name, bucket_encrypt, stdout = $stdout)

  random_string = ('a'..'z').to_a.shuffle[0,16].join

  config = AwsHelpers::Config.new({})

  stack_name_1 = 'my-stack-name-1'
  stack_name_2 = 'my-stack-name-2'

  template_json_1 = IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'cloudformation.template.json'))
  template_json_2 = IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'cloudformation.template.json'))

  s3_bucket_name = "new-bucket-#{random_string}"
  bucket_encrypt = true

  s3_bucket_location = 'ap-southeast-2'

  objects = [ { key: stack_name_1 }, { key: stack_name_2  } ]

  url = "https://#{s3_bucket_name}.s3-#{s3_bucket_location}.amazonaws.com"

  after(:each) do
    client = Aws::S3::Client.new
    client.delete_objects(bucket: s3_bucket_name, delete: { objects: objects } )
    client.delete_bucket(bucket: s3_bucket_name) # bucket will be deleted
  end

  describe '#S3UploadTemplate' do

    it 'create the template and upload the stack template' do
      expect(upload_template(config, stack_name_1, template_json_1, s3_bucket_name, bucket_encrypt)).to eq(url) #bucket will be created
      expect(upload_template(config, stack_name_2, template_json_2, s3_bucket_name, bucket_encrypt)).to eq(url) #bucket will be updated
    end

  end

  private

  def upload_template(config, stack_name, template_json, s3_bucket_name, bucket_encrypt)
    AwsHelpers::Actions::S3::S3UploadTemplate.new(config, stack_name, template_json, s3_bucket_name, bucket_encrypt).execute
  end

end
