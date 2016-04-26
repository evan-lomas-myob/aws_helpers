require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::StackProvision do

  describe '#execute' do

    let(:cloud_formation_client) { instance_double(Aws::CloudFormation::Client) }
    let(:aws_s3_client) { instance_double(Aws::S3::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloud_formation_client, aws_s3_client: aws_s3_client) }
    let(:stdout) { instance_double(IO) }

    let(:stack_upload_template) { instance_double(AwsHelpers::Actions::S3::UploadTemplate) }
    let(:stack_exists) { instance_double(AwsHelpers::Actions::CloudFormation::StackExists) }
    let(:stack_rollback_complete) { instance_double(AwsHelpers::Actions::CloudFormation::StackRollbackComplete) }
    let(:stack_delete) { instance_double(AwsHelpers::Actions::CloudFormation::StackDelete) }
    let(:stack_update) { instance_double(AwsHelpers::Actions::CloudFormation::StackUpdate) }
    let(:stack_create) { instance_double(AwsHelpers::Actions::CloudFormation::StackCreate) }
    let(:stack_information) { instance_double(AwsHelpers::Actions::CloudFormation::StackInformation) }

    let(:stack_name) { 'stack_name' }
    let(:template_json) { 'json' }
    let(:template_url) { 'https://my-bucket-url' }
    let(:polling) { {delay: 1, max_attempts: 2} }

    before(:each) do
      allow(AwsHelpers::Actions::S3::UploadTemplate).to receive(:new).and_return(stack_upload_template)
      allow(stack_upload_template).to receive(:execute).and_return(template_url)
      allow(AwsHelpers::Actions::CloudFormation::StackExists).to receive(:new).and_return(stack_exists)
      allow(AwsHelpers::Actions::CloudFormation::StackDelete).to receive(:new).and_return(stack_delete)
      allow(stack_delete).to receive(:execute)
      allow(AwsHelpers::Actions::CloudFormation::StackUpdate).to receive(:new).and_return(stack_update)
      allow(stack_update).to receive(:execute)
      allow(AwsHelpers::Actions::CloudFormation::StackCreate).to receive(:new).and_return(stack_create)
      allow(stack_create).to receive(:execute)
      allow(AwsHelpers::Actions::CloudFormation::StackInformation).to receive(:new).and_return(stack_information)
      allow(stack_information).to receive(:execute)
    end

    context 'bucket_name option not provided' do

      after(:each) do
        described_class.new(config, stack_name, template_json, stdout: stdout, stack_polling: polling).execute
      end

      context 'the stack does not exist' do

        before(:each) do
          allow(stack_exists).to receive(:execute).and_return(false)
        end

        it 'should call AwsHelpers::Actions::CloudFormation::StackExists with correct parameters' do
          expect(AwsHelpers::Actions::CloudFormation::StackExists).to receive(:new).with(config, stack_name)
        end

        it 'should call AwsHelpers::Actions::CloudFormation::StackExists #execute' do
          expect(stack_exists).to receive(:execute)
        end

        it 'should call AwsHelpers::Actions::CloudFormation::StackCreate #new with the correct parameters' do
          expect(AwsHelpers::Actions::CloudFormation::StackCreate).to receive(:new).with(config, {stack_name: stack_name, template_body: template_json}, stdout: stdout, delay: 1, max_attempts: 2)
        end

        it 'should call AwsHelpers::Actions::CloudFormation::StackCreate #execute' do
          expect(stack_create).to receive(:execute)
        end

        it 'should call AwsHelpers::Actions::CloudFormation::StackInformation #new with the correct parameters' do
          expect(AwsHelpers::Actions::CloudFormation::StackInformation).to receive(:new).with(config, stack_name, 'outputs')
        end

        it 'should call AwsHelpers::Actions::CloudFormation::StackInformation #execute' do
          expect(stack_information).to receive(:execute)
        end

      end

      context 'the stack exists' do

        before(:each) do
          allow(stack_exists).to receive(:execute).and_return(true)
          allow(AwsHelpers::Actions::CloudFormation::StackRollbackComplete).to receive(:new).and_return(stack_rollback_complete)
        end

        context 'the stack is in a not in RollbackComplete state' do

          before(:each) do
            allow(stack_rollback_complete).to receive(:execute).and_return(false)
          end

          it 'should call AwsHelpers::Actions::CloudFormation::StackRollbackComplete with correct parameters' do
            expect(AwsHelpers::Actions::CloudFormation::StackRollbackComplete).to receive(:new).with(config, stack_name)
          end

          it 'should call AwsHelpers::Actions::CloudFormation::StackRollbackComplete #execute' do
            expect(stack_rollback_complete).to receive(:execute)
          end

          it 'should not call AwsHelpers::Actions::CloudFormation::StackDelete' do
            expect(AwsHelpers::Actions::CloudFormation::StackDelete).to_not receive(:new)
          end

          it 'should call AwsHelpers::Actions::CloudFormation::StackUpdate #new with the correct parameters' do
            expect(AwsHelpers::Actions::CloudFormation::StackUpdate).to receive(:new).with(config, {stack_name: stack_name, template_body: template_json}, stdout: stdout, delay: 1, max_attempts: 2)
          end

          it 'should call AwsHelpers::Actions::CloudFormation::StackUpdate #execute' do
            expect(stack_update).to receive(:execute)
          end

          it 'should call AwsHelpers::Actions::CloudFormation::StackInformation #new with the correct parameters' do
            expect(AwsHelpers::Actions::CloudFormation::StackInformation).to receive(:new).with(config, stack_name, 'outputs')
          end

          it 'should call AwsHelpers::Actions::CloudFormation::StackInformation #execute' do
            expect(stack_information).to receive(:execute)
          end

        end

        context 'the stack is in RollbackComplete state' do

          before(:each) do
            allow(stack_rollback_complete).to receive(:execute).and_return(true)
          end

          it 'should call AwsHelpers::Actions::CloudFormation::StackDelete #new with correct parameters' do
            expect(AwsHelpers::Actions::CloudFormation::StackDelete).to receive(:new).with(config, stack_name, stdout: stdout, delay: 1, max_attempts: 2)
          end

          it 'should delete the stack by calling AwsHelpers::Actions::CloudFormation::StackDelete #execute' do
            expect(stack_delete).to receive(:execute)
          end

          it 'should call AwsHelpers::Actions::CloudFormation::StackUpdate #new with the correct parameters' do
            expect(AwsHelpers::Actions::CloudFormation::StackUpdate).to receive(:new).with(config, {stack_name: stack_name, template_body: template_json}, stdout: stdout, delay: 1, max_attempts: 2)
          end

          it 'should call AwsHelpers::Actions::CloudFormation::StackUpdate #execute' do
            expect(stack_update).to receive(:execute)
          end

          it 'should call AwsHelpers::Actions::CloudFormation::StackInformation #new with the correct parameters' do
            expect(AwsHelpers::Actions::CloudFormation::StackInformation).to receive(:new).with(config, stack_name, 'outputs')
          end

          it 'should call AwsHelpers::Actions::CloudFormation::StackInformation #execute' do
            expect(stack_information).to receive(:execute)
          end

        end

      end

    end

    context 'bucket_name option provided' do

      let(:bucket_name) { 'bucket_name' }

      before(:each) do
        allow(stack_exists).to receive(:execute).and_return(false)
      end

      context 'bucket_polling provided' do

        after(:each) do
          described_class.new(config, stack_name, template_json, bucket_name: bucket_name, stdout: stdout, bucket_polling: polling).execute
        end

        it 'should call AwsHelpers::Actions::S3::UploadTemplate #new with correct parameters' do
          expect(AwsHelpers::Actions::S3::UploadTemplate).to receive(:new).with(config, stack_name, template_json, bucket_name, stdout: stdout, bucket_encrypt: nil, delay: 1, max_attempts: 2)
        end

        it 'should call AwsHelpers::Actions::S3::UploadTemplate #execute' do
          expect(stack_upload_template).to receive(:execute)
        end

      end

      context 'bucket_encrypt option not provided' do

        after(:each) do
          described_class.new(config, stack_name, template_json, bucket_name: bucket_name, stdout: stdout).execute
        end

        it 'should call AwsHelpers::Actions::S3::UploadTemplate #new with correct parameters' do
          expect(AwsHelpers::Actions::S3::UploadTemplate).to receive(:new).with(config, stack_name, template_json, bucket_name, stdout: stdout, bucket_encrypt: nil)
        end

        it 'should call AwsHelpers::Actions::S3::UploadTemplate #execute' do
          expect(stack_upload_template).to receive(:execute)
        end

      end

      context 'bucket_encrypt provided' do

        let(:bucket_encrypt) { true }

        after(:each) do
          described_class.new(config, stack_name, template_json, bucket_name: bucket_name, stdout: stdout, bucket_encrypt: bucket_encrypt).execute
        end

        it 'should call AwsHelpers::Actions::S3::UploadTemplate #new with correct parameters' do
          expect(AwsHelpers::Actions::S3::UploadTemplate).to receive(:new).with(config, stack_name, template_json, bucket_name, stdout: stdout, bucket_encrypt: bucket_encrypt)
        end

        it 'should call AwsHelpers::Actions::S3::UploadTemplate #execute' do
          expect(stack_upload_template).to receive(:execute)
        end

      end

    end

  end
end
