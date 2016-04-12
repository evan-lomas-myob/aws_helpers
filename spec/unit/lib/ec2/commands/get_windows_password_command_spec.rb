require 'aws_helpers/ec2_commands/commands/get_windows_password_command'
require 'aws_helpers/ec2_commands/requests/get_windows_password_request'

describe AwsHelpers::EC2Commands::Commands::GetWindowsPasswordCommand do
  let(:instance_id) { '123' }
  let(:pem_path) { 'MyPEM' }
  let(:private_key) { instance_double(OpenSSL::PKey::RSA) }
  let(:password_data) { Aws::EC2::Types::GetPasswordDataResult.new(password_data: 'password_data') }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::GetWindowsPasswordRequest.new }

  before do
    request.instance_id = instance_id
    request.pem_path = pem_path
    @command = AwsHelpers::EC2Commands::Commands::GetWindowsPasswordCommand.new(config, request)
    allow(ec2_client).to receive(:get_password_data).with(instance_id: instance_id).and_return(password_data)
    allow(File).to receive(:read).with(pem_path).and_return(pem_path)
    allow(OpenSSL::PKey::RSA).to receive(:new).with(pem_path).and_return(private_key)
    allow(Base64).to receive(:decode64).with('password_data').and_return('decoded_data')
    allow(private_key).to receive(:private_decrypt).with('decoded_data').and_return('decrypted_data')
  end

  it 'returns the decrypted password' do
    @command.execute
    expect(request.windows_password).to eq('decrypted_data')
  end
end
