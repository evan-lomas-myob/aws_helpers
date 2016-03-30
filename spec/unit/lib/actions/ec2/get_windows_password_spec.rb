require 'base64'
require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/get_windows_password'

include AwsHelpers::Actions::EC2

describe GetWindowsPassword do
  let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
  let(:stdout) { instance_double(IO) }
  let(:options) { { stdout: stdout } }

  let(:instance_id) { 'my-instance_id' }
  let(:path_to_pem) { '/path_to_pem_file/pem.file' }

# rubocop:disable all
  let(:pkcs8) { '-----BEGIN RSA PRIVATE KEY-----  
MIIEowIBAAKCAQEA+WjRcGw+jQUv1zagH2Y2/0RS3mW20aegNSiWB+uPOkRQvL3U
8ZSZU27QxIPIk+0bw3AZqEKGJ/BahbdCdfXELCwvPmWyWuJrvsYb+08RifAGz/V/
Y+Uoy1xIG0kEks7rr4eQDBy8LvoKfJmAR9FcCbjTSeY3Ej+MrxKOGGPZPHUwxlk0
Qg7ayGL6KbsoSvDbf1T8xN2kPWaT862N246LXTDQrp2TAnOb57fH35c3LeN3dyYT
DoQ3oLT85mgFHJEwpL+nUZ+gDhGzuZI1KFPK1J92Phk/IC/jFqhFOOtPLZbNslOP
vniaOU9shkW2bfBTd45X7S4eRjylUo5bWr+crwIDAQABAoIBAQCRd2EwgPG6rlvI
2kNqDOPm3qK2s/x9K5d1acaXt/xBr7anXtDkVhdXYjrBY1uJa7HVu3w7dxFoGfey
JcDNrBpO6TZk3ku4VnchPcr0OJmyKhzPDhDO4sl4Usp7n4rbVXSBXD/X0Kqxe4TC
R4VaXfGgefxCDdPxAL+9HMVj1FjPuSOEWp6B0jRO85Vi0K8G7SeRaa8vA3oRPfLu
g8qIr7K3xbuxzYkkg1KRBT4HbeV8krMZkpc1DIeXS76g5UEMRk4Z/edctj34StFo
AeQzl8/IXjiSBKVNsb96evGZNsXbqGQ6jXCJKR7Zu3SGSFnb4Zq1nKgWfJ+2VYDQ
zcSqygEBAoGBAP8vbB0ELHCq0S0MpuyJdgJJNhiGWOpUhow34yasLkjxL/eEpFYM
jdHRsAX5gdaJ+jHayPgNvfd9E5Ba40PO+ZCG/Qn2cluKDYlZFwU0ap1ReBRc55A5
daIz6gFsF/zLaVGXb6DqVBQytQw/9JL3VININkmsKlUMBuT5cX4W0lxnAoGBAPo0
rMblsFStG68seBeXtsKA6I7+2VHvW6mQxnwau7IjL8KcP8glEhr2C4OpkQ7qeS/h
+mhtTNz+Gl2QvkkrQKamoKL25KZ3vc4YV4d2xvjKGw2LfImYPaXah4iRS/za9MyP
kvRbT6eMDXmo0N6jwKGhT3+bGlrVxKbo0iOA6JB5AoGATwIcxCMdq0iH+R24tPWe
bvjB4ff+oZbIDbPkBX472mOqiUUtKGM8qaD1kfP9ajJQH41wubRvg6fbHc+2G7GC
fWf+Ak6me4cTx9mokfj3pXuq5QsauwG/VRgjtIsGJkPIePWdH0JOA+7rNT6796DS
Ls9113uRo8FUhSJiLDreqLMCgYAAheWqkMZalvYM2rHxkq6eH3jc+6lmo3J0m0ne
7otf5vTtmjgD6hfsmIETqGIWPuU79WP5nejgOWPCuE+9hWqgLo79aDi4JF3wNVrR
fK0TzhBaaeU7wGa4lwlbfrpC8A488zviaOJ0vjU1AOZW4M7BR74LzT4z3GiJ1MjD
rDxQOQKBgHQ04dOCGZiEj7aFpJFnSoUpmFusVRJv+B00s6R51iW0j72wcW0rPFD+
OC3W27eCucJTy5eTdNoevoq7xXh7gRr5fhwFrEadqeSPiULRdWrODkCqiqgiA4WR
+t8YMPg3kx2JXe5cJZ5WP6zayKpOXrURuePb3srQRmCsgnLXXeOQ
-----END RSA PRIVATE KEY-----
' } 

  let(:password_data) { '9f6nkt7MdJvgfQt/+2+zhd7ZV86FYRtjSiP1yvpv7pEmCWoYVE6qbcKof81VY48W
Rhcq5br0jqBv21u3JhprqDZulUkY6Jcq5N959lffRADhkOp4dKkjwpGn3HTEE2s7
+VW6cWL8vxD0Y0eQZU4bVgzHtPIYJmchX0KhVQIVUoC/AkHaaFMc/UnddOnM5gr4
tDvrRBe716vn+H2e/P5nSs1Q/V2H3ZdHtqbCN8SHm3PIX0q2fTmvXyKd9psNnfvK
XipewzZEyjdrrYTOVZ0Dn7ZYjs4anmEsl2Uw/GZp5m92U350e+TLEfrqoreB7ax8
cgjPr3q6+hb7avSNivEdgQ==' }
# rubocop:enable all

  let(:response) { instance_double(Aws::EC2::Types::GetPasswordDataResult, password_data: password_data) }
  let(:error_response) { instance_double(Aws::EC2::Types::GetPasswordDataResult, password_data: 'BADPASSWORDDATA' ) }

  let(:password) { "my-password\n" }

  before(:each) do
    allow(File).to receive(:read).with(path_to_pem).and_return(pkcs8)
    allow(stdout).to receive(:puts).and_return(anything)
  end

  it 'should get the password data' do
    allow(File).to receive(:read).with(path_to_pem).and_return(pkcs8)
    expect(aws_ec2_client).to receive(:get_password_data).with(instance_id: instance_id).and_return(response)
    GetWindowsPassword.new(config, instance_id, path_to_pem, options).get_password
  end

  it 'should read the pem file' do
    expect(File).to receive(:read).with(path_to_pem).and_return(pkcs8)
    allow(aws_ec2_client).to receive(:get_password_data).with(instance_id: instance_id).and_return(response)
    GetWindowsPassword.new(config, instance_id, path_to_pem, options).get_password
  end

  it 'should decrypt and return the correct password' do
    allow(File).to receive(:read).with(path_to_pem).and_return(pkcs8)
    allow(aws_ec2_client).to receive(:get_password_data).with(instance_id: instance_id).and_return(response)
    expect(GetWindowsPassword.new(config, instance_id, path_to_pem, options).get_password).to eq(password)
  end

  it 'should throw and error' do
    allow(File).to receive(:read).with(path_to_pem).and_return(pkcs8)
    allow(aws_ec2_client).to receive(:get_password_data).with(instance_id: instance_id).and_return(error_response)
    expect { GetWindowsPassword.new(config, instance_id, path_to_pem, options).get_password }.to raise_error(OpenSSL::PKey::RSAError)
  end
end