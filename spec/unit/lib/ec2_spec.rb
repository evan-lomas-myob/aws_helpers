# require 'time'
# require 'aws_helpers/utilities/time'
require 'aws_helpers/ec2'

describe AwsHelpers::EC2 do
  let(:instance_id) { '123' }
  let(:image_id) { '456' }
  let(:image_name) { 'Batman' }
  let(:user_id) { '789' }
  let(:vpc_name) { 'Robin' }
  let(:pem_path) { '/files/gotham/bwayne' }
  let(:security_group_name) { 'Penguin' }
  let(:config) { instance_double(AwsHelpers::Config) }

  before do
    allow(AwsHelpers::Config).to receive(:new).and_return(config)
  end

  describe '#initialize' do
    it 'should call AwsHelpers::Client initialize method' do
      options = { endpoint: 'http://endpoint' }
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::EC2.new(options)
    end
  end

  describe '#image_create' do
    let(:request) { ImageCreateRequest.new(instance_id: instance_id, image_name: image_name) }
    let(:director) { instance_double(ImageCreateDirector) }
    let(:time) { Time.now }

    before do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(ImageCreateRequest).to receive(:new).and_return(request)
      allow(ImageCreateDirector).to receive(:new).and_return(director)
      allow(director).to receive(:create)
      allow(Time).to receive(:now).and_return(time)
    end

    it 'should create a ImageAddUserRequest' do
      expect(ImageCreateRequest)
        .to receive(:new)
      AwsHelpers::EC2.new.image_create(instance_id, image_name)
    end

    it 'should add tags to the request if they are provided' do
      expect(request)
        .to receive(:tags=)
        .with([{ key: 'Name', value: image_name }, { key: 'Date', value: time.to_s }])
      AwsHelpers::EC2.new.image_create(instance_id, image_name, options: { tags: [{ key: 'Occupation', value: 'Caped Crusader' }] })
    end

    it 'should create a ImageCreateDirector with the config' do
      expect(ImageCreateDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::EC2.new.image_create(instance_id, image_name)
    end

    it 'should call create on the ImageCreateDirector' do
      expect(director)
        .to receive(:create)
        .with(request)
      AwsHelpers::EC2.new.image_create(instance_id, image_name)
    end
  end

  describe '#image_delete' do
    let(:request) { ImageDeleteRequest.new(image_id: image_id) }
    let(:director) { instance_double(ImageDeleteDirector) }

    before do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(ImageDeleteRequest).to receive(:new).and_return(request)
      allow(ImageDeleteDirector).to receive(:new).and_return(director)
      allow(director).to receive(:delete)
    end

    it 'should delete a ImageAddUserRequest' do
      expect(ImageDeleteRequest)
        .to receive(:new)
      AwsHelpers::EC2.new.image_delete(image_id)
    end

    it 'should delete a ImageDeleteDirector with the config' do
      expect(ImageDeleteDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::EC2.new.image_delete(image_id)
    end

    it 'should call delete on the ImageDeleteDirector' do
      expect(director)
        .to receive(:delete)
        .with(request)
      AwsHelpers::EC2.new.image_delete(image_id)
    end
  end

  describe '#image_add_user' do
    let(:request) { ImageAddUserRequest.new(image_id: image_id) }
    let(:director) { instance_double(ImageAddUserDirector) }

    before do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(ImageAddUserRequest).to receive(:new).and_return(request)
      allow(ImageAddUserDirector).to receive(:new).and_return(director)
      allow(director).to receive(:add)
    end

    it 'should create a ImageAddUserRequest' do
      expect(ImageAddUserRequest)
        .to receive(:new)
      AwsHelpers::EC2.new.image_add_user(image_id, user_id)
    end

    it 'should create a ImageAddUserDirector with the config' do
      expect(ImageAddUserDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::EC2.new.image_add_user(image_id, user_id)
    end

    it 'should call add on the ImageAddUserDirector' do
      expect(director)
        .to receive(:add)
        .with(request)
      AwsHelpers::EC2.new.image_add_user(image_id, user_id)
    end
  end

  describe '#get_image_ids' do
    let(:request) { GetImageIdsRequest.new(image_id: image_id) }
    let(:director) { instance_double(GetImageIdsDirector) }
    # let!(:now) { Time.now }

    before do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(GetImageIdsRequest).to receive(:new).and_return(request)
      allow(GetImageIdsDirector).to receive(:new).and_return(director)
      allow(director).to receive(:get)
      # allow(Time).to receive(:now).and_return(now)
      # allow(now).to receive(:prev_year).and_return(now)
    end

    it 'should create a new GetImageIdsRequest' do
      expect(GetImageIdsRequest)
        .to receive(:new)
      AwsHelpers::EC2.new.get_image_ids(image_name)
    end

    it 'should create a GetImageIdsDirector with the config' do
      expect(GetImageIdsDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::EC2.new.get_image_ids(image_name)
    end

    it 'should call get on the GetImageIdsDirector' do
      expect(director)
        .to receive(:get)
        .with(request)
      AwsHelpers::EC2.new.get_image_ids(image_name)
    end
  end

  describe '#images_delete_by_time' do
    let(:images_delete_by_time) { instance_double(ImagesDeleteByTime) }
    let(:time) { Time.parse('01-Jan-2015') }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(ImagesDeleteByTime).to receive(:new).and_return(images_delete_by_time)
      allow(images_delete_by_time).to receive(:execute)
    end

    subject { AwsHelpers::EC2.new.images_delete_by_time(image_name, time) }

    it 'should create ImagesDeleteByTime with default parameters' do
      expect(ImagesDeleteByTime).to receive(:new).with(config, image_name, time, {})
      subject
    end

    it 'should call ImagesDeleteByTime execute method' do
      expect(images_delete_by_time).to receive(:execute)
      subject
    end
  end

  describe '#images_find_by_tags' do
    let(:images_find_by_tags) { instance_double(ImagesFindByTags) }
    let(:tags) { %w('tag1', 'tag2') }

    before(:each) do
      allow(ImagesFindByTags).to receive(:new).and_return(images_find_by_tags)
      allow(images_find_by_tags).to receive(:execute)
    end

    subject { AwsHelpers::EC2.new.images_find_by_tags(tags) }

    it 'should create ImagesFindByTags' do
      expect(ImagesFindByTags).to receive(:new).with(config, tags)
      subject
    end

    it 'should call ImagesFindByTags execute method' do
      expect(images_find_by_tags).to receive(:execute)
      subject
    end
  end

  describe '#instance_create' do
    let(:request) { InstanceCreateRequest.new }
    let(:director) { instance_double(InstanceCreateDirector) }

    before do
      request.image_id = image_id
      allow(InstanceCreateRequest).to receive(:new).and_return(request)
      allow(InstanceCreateDirector).to receive(:new).and_return(director)
      allow(director).to receive(:create)
    end

    it 'should create a InstanceCreateRequest' do
      expect(InstanceCreateRequest)
        .to receive(:new)
      AwsHelpers::EC2.new.instance_create(image_id)
    end

    it 'should create a InstanceCreateDirector with the config' do
      expect(InstanceCreateDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::EC2.new.instance_create(image_id)
    end

    it 'should call create on the InstanceCreateDirector' do
      expect(director)
        .to receive(:create)
        .with(request)
      AwsHelpers::EC2.new.instance_create(image_id)
    end
  end

  describe '#instance_start' do
    let(:request) { InstanceStartRequest.new(image_id: image_id) }
    let(:director) { instance_double(InstanceStartDirector) }

    before do
      allow(InstanceStartRequest).to receive(:new).and_return(request)
      allow(InstanceStartDirector).to receive(:new).and_return(director)
      allow(director).to receive(:start)
    end

    it 'should delete a InstanceStartRequest' do
      expect(InstanceStartRequest)
        .to receive(:new)
      AwsHelpers::EC2.new.instance_start(instance_id)
    end

    it 'should delete a InstanceStartDirector with the config' do
      expect(InstanceStartDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::EC2.new.instance_start(instance_id)
    end

    it 'should call delete on the InstanceStartDirector' do
      expect(director)
        .to receive(:start)
        .with(request)
      AwsHelpers::EC2.new.instance_start(instance_id)
    end
  end

  describe '#instance_stop' do
    let(:request) { InstanceStopRequest.new(image_id: image_id) }
    let(:director) { instance_double(InstanceStopDirector) }

    before do
      allow(InstanceStopRequest).to receive(:new).and_return(request)
      allow(InstanceStopDirector).to receive(:new).and_return(director)
      allow(director).to receive(:stop)
    end

    it 'should delete a InstanceStopRequest' do
      expect(InstanceStopRequest)
        .to receive(:new)
      AwsHelpers::EC2.new.instance_stop(instance_id)
    end

    it 'should delete a InstanceStopDirector with the config' do
      expect(InstanceStopDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::EC2.new.instance_stop(instance_id)
    end

    it 'should call delete on the InstanceStopDirector' do
      expect(director)
        .to receive(:stop)
        .with(request)
      AwsHelpers::EC2.new.instance_stop(instance_id)
    end
  end

  describe '#instances_find_by_tags' do
    let(:instances_find_by_tags) { instance_double(InstancesFindByTags) }
    let(:tags) { %w('tag1', 'tag2') }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(InstancesFindByTags).to receive(:new).and_return(instances_find_by_tags)
      allow(instances_find_by_tags).to receive(:execute)
    end

    subject { AwsHelpers::EC2.new.instances_find_by_tags(tags) }

    it 'should create InstancesFindByTags' do
      expect(InstancesFindByTags).to receive(:new).with(config, tags)
      subject
    end

    it 'should call InstancesFindByTags execute method' do
      expect(instances_find_by_tags).to receive(:execute)
      subject
    end
  end

  describe '#instances_find_by_ids' do
    let(:instances_find_by_ids) { instance_double(InstancesFindByIds) }
    let(:ids) { %w('id1', 'id2') }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(InstancesFindByIds).to receive(:new).and_return(instances_find_by_ids)
      allow(instances_find_by_ids).to receive(:execute)
    end

    subject { AwsHelpers::EC2.new.instances_find_by_ids(ids) }

    it 'should create InstancesFindByIds' do
      expect(InstancesFindByIds).to receive(:new).with(config, ids)
      subject
    end

    it 'should call InstancesFindByIds execute method' do
      expect(instances_find_by_ids).to receive(:execute)
      subject
    end
  end

  describe '#instance_terminate' do
    let(:request) { InstanceTerminateRequest.new(image_id: image_id) }
    let(:director) { instance_double(InstanceTerminateDirector) }

    before do
      allow(InstanceTerminateRequest).to receive(:new).and_return(request)
      allow(InstanceTerminateDirector).to receive(:new).and_return(director)
      allow(director).to receive(:terminate)
    end

    it 'should delete a InstanceTerminateRequest' do
      expect(InstanceTerminateRequest)
        .to receive(:new)
      AwsHelpers::EC2.new.instance_terminate(instance_id)
    end

    it 'should delete a InstanceTerminateDirector with the config' do
      expect(InstanceTerminateDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::EC2.new.instance_terminate(instance_id)
    end

    it 'should call delete on the InstanceTerminateDirector' do
      expect(director)
        .to receive(:terminate)
        .with(request)
      AwsHelpers::EC2.new.instance_terminate(instance_id)
    end
  end

  describe '#poll_instance_healthy' do
    let(:request) { PollInstanceHealthyRequest.new(image_id: image_id) }
    let(:director) { instance_double(PollInstanceHealthyDirector) }

    before do
      allow(PollInstanceHealthyRequest).to receive(:new).and_return(request)
      allow(PollInstanceHealthyDirector).to receive(:new).and_return(director)
      allow(director).to receive(:execute)
    end

    it 'should delete a PollInstanceHealthyRequest' do
      expect(PollInstanceHealthyRequest)
        .to receive(:new)
      AwsHelpers::EC2.new.poll_instance_healthy(instance_id)
    end

    it 'should delete a PollInstanceHealthyDirector with the config' do
      expect(PollInstanceHealthyDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::EC2.new.poll_instance_healthy(instance_id)
    end

    it 'should call delete on the PollInstanceHealthyDirector' do
      expect(director)
        .to receive(:execute)
        .with(request)
      AwsHelpers::EC2.new.poll_instance_healthy(instance_id)
    end
  end

  describe '#poll_instance_stopped' do
    let(:request) { PollInstanceStoppedRequest.new(image_id: image_id) }
    let(:director) { instance_double(PollInstanceStoppedDirector) }

    before do
      allow(PollInstanceStoppedRequest).to receive(:new).and_return(request)
      allow(PollInstanceStoppedDirector).to receive(:new).and_return(director)
      allow(director).to receive(:execute)
    end

    it 'should delete a PollInstanceStoppedRequest' do
      expect(PollInstanceStoppedRequest)
        .to receive(:new)
      AwsHelpers::EC2.new.poll_instance_stopped(instance_id)
    end

    it 'should delete a PollInstanceStoppedDirector with the config' do
      expect(PollInstanceStoppedDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::EC2.new.poll_instance_stopped(instance_id)
    end

    it 'should call delete on the PollInstanceHealthyDirector' do
      expect(director)
        .to receive(:execute)
        .with(request)
      AwsHelpers::EC2.new.poll_instance_stopped(instance_id)
    end
  end

  describe '#poll_instance_state' do
    let(:poll_inst_state) { instance_double(PollInstanceState) }
    let(:state) { 'running' }
    let(:image_id) { 'image_id' }
    let(:options) { {} } # just use defaults

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(poll_inst_state).to receive(:execute)
      allow(PollInstanceState).to receive(:new).with(config, image_id, state, options).and_return(poll_inst_state)
    end

    subject { AwsHelpers::EC2.new.poll_instance_state(image_id, state, options) }

    it 'should create PollInstanceState' do
      expect(PollInstanceState).to receive(:new).with(config, image_id, state, options).and_return(poll_inst_state)
      subject
    end

    it 'should call PollInstanceState execute method' do
      expect(poll_inst_state).to receive(:execute)
      subject
    end
  end

  describe '#get_windows_password' do
    let(:request) { GetWindowsPasswordRequest.new(image_id: image_id) }
    let(:director) { instance_double(GetWindowsPasswordDirector) }

    before do
      allow(GetWindowsPasswordRequest).to receive(:new).and_return(request)
      allow(GetWindowsPasswordDirector).to receive(:new).and_return(director)
      allow(director).to receive(:get)
    end

    it 'should delete a GetWindowsPasswordRequest' do
      expect(GetWindowsPasswordRequest)
        .to receive(:new)
      AwsHelpers::EC2.new.get_windows_password(instance_id, pem_path)
    end

    it 'should delete a GetWindowsPasswordDirector with the config' do
      expect(GetWindowsPasswordDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::EC2.new.get_windows_password(instance_id, pem_path)
    end

    it 'should call delete on the GetWindowsPasswordDirector' do
      expect(director)
        .to receive(:get)
        .with(request)
      AwsHelpers::EC2.new.get_windows_password(instance_id, pem_path)
    end
  end

  describe '#get_vpc_id_by_name' do
    let(:request) { GetVpcIdRequest.new(image_id: image_id) }
    let(:director) { instance_double(GetVpcIdDirector) }

    before do
      allow(GetVpcIdRequest).to receive(:new).and_return(request)
      allow(GetVpcIdDirector).to receive(:new).and_return(director)
      allow(director).to receive(:get)
    end

    it 'should delete a GetVpcIdRequest' do
      expect(GetVpcIdRequest)
        .to receive(:new)
      AwsHelpers::EC2.new.get_vpc_id_by_name(vpc_name)
    end

    it 'should delete a GetVpcIdDirector with the config' do
      expect(GetVpcIdDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::EC2.new.get_vpc_id_by_name(vpc_name)
    end

    it 'should call delete on the GetVpcIdDirector' do
      expect(director)
        .to receive(:get)
        .with(request)
      AwsHelpers::EC2.new.get_vpc_id_by_name(vpc_name)
    end
  end

  describe '#get_security_group_id_by_name' do
    let(:request) { GetSecurityGroupIdRequest.new(image_id: image_id) }
    let(:director) { instance_double(GetSecurityGroupIdDirector) }

    before do
      allow(GetSecurityGroupIdRequest).to receive(:new).and_return(request)
      allow(GetSecurityGroupIdDirector).to receive(:new).and_return(director)
      allow(director).to receive(:get)
    end

    it 'should delete a GetSecurityGroupIdRequest' do
      expect(GetSecurityGroupIdRequest)
        .to receive(:new)
      AwsHelpers::EC2.new.get_group_id_by_name(security_group_name)
    end

    it 'should delete a GetSecurityGroupIdDirector with the config' do
      expect(GetSecurityGroupIdDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::EC2.new.get_group_id_by_name(security_group_name)
    end

    it 'should call delete on the GetSecurityGroupIdDirector' do
      expect(director)
        .to receive(:get)
        .with(request)
      AwsHelpers::EC2.new.get_group_id_by_name(security_group_name)
    end
  end

  # describe '#instances_find_by_tags' do

  #   let(:vpcs_find_by_tags) { double(VpcsFindByTags) }
  #   let(:client) { instance_double(Aws::ElasticLoadBalancing::Client) }
  #   let(:known_tags) { {'Name' => 'Batman' } }
  #   let(:unknown_tags) { {'Name' => 'Bruce Wayne' } }

  #   before(:each) do
  #     allow(AwsHelpers::Config).to receive(:new).and_return(config)
  #     allow(VpcsFindByTags).to receive(:new).with(anything, anything).and_return(vpcs_find_by_tags)
  #     allow(vpcs_find_by_tags).to receive(:execute)
  #   end

  #   subject { AwsHelpers::EC2.new.vpcs_find_by_tags(tags) }

  #   it 'should return the VPC if it exists' do
  #     vpcs = AwsHelpers::EC2.new.vpcs_find_by_tags(known_tags)
  #     expect(vpcs).to_not be_empty
  #     expect(vpcs.first.vpc_id).to eq(13)
  #   end

  #   it 'should return nil if no VPC is found' do
  #     vpcs = AwsHelpers::EC2.new.vpcs_find_by_tags(unknown_tags)
  #     expect(vpcs).to be_empty
  #   end


  #   it 'should create VpcsFindByTags' do
  #     expect(VpcsFindByTags).to receive(:new).with(config, anything).and_return(vpcs_find_by_tags)
  #     subject
  #   end

  #   it 'should call VpcsFindByTags execute method' do
  #     expect(vpcs_find_by_tags).to receive(:execute)
  #     subject
  #   end
  # end

  # describe '#instances_find_by_tags' do

  #   let(:vpcs_find_by_tags) { double(VpcsFindByTags) }
  #   let(:client) { instance_double(Aws::ElasticLoadBalancing::Client) }
  #   let(:known_tags) { {'Name' => 'Batman' } }
  #   let(:unknown_tags) { {'Name' => 'Bruce Wayne' } }

  #   before(:each) do
  #     allow(AwsHelpers::Config).to receive(:new).and_return(config)
  #     allow(VpcsFindByTags).to receive(:new).with(anything, anything).and_return(vpcs_find_by_tags)
  #     allow(vpcs_find_by_tags).to receive(:execute)
  #   end

  #   subject { AwsHelpers::EC2.new.vpcs_find_by_tags(tags) }

  #   it 'should return the VPC if it exists' do
  #     vpcs = AwsHelpers::EC2.new.vpcs_find_by_tags(known_tags)
  #     expect(vpcs).to_not be_empty
  #     expect(vpcs.first.vpc_id).to eq(13)
  #   end

  #   it 'should return nil if no VPC is found' do
  #     vpcs = AwsHelpers::EC2.new.vpcs_find_by_tags(unknown_tags)
  #     expect(vpcs).to be_empty
  #   end


  #   it 'should create VpcsFindByTags' do
  #     expect(VpcsFindByTags).to receive(:new).with(config, anything).and_return(vpcs_find_by_tags)
  #     subject
  #   end

  #   it 'should call VpcsFindByTags execute method' do
  #     expect(vpcs_find_by_tags).to receive(:execute)
  #     subject
  #   end
  # end

end
