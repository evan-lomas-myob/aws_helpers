require 'time'
require 'aws_helpers/ec2'

describe AwsHelpers::EC2 do


  let(:config) { double(AwsHelpers::Config) }
  let(:image_name) { 'ec2_name' }

  describe '#initialize' do

    it 'should call AwsHelpers::Client initialize method' do
      options = { endpoint: 'http://endpoint' }
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::EC2.new(options)
    end

  end

  describe '#image_create' do

    let(:image_create) { double(ImageCreate) }

    let(:instance_id) { 'ec2_id' }
    let(:tags) { %w('tag1', 'tag2') }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(ImageCreate).to receive(:new).and_return(image_create)
      allow(image_create).to receive(:execute)
    end

    it 'should create ImageCreate with default parameters' do
      expect(ImageCreate).to receive(:new).with(config, image_name, instance_id, tags)
      AwsHelpers::EC2.new.image_create(image_name, instance_id, tags)
    end

    it 'should call ImageCreate execute method' do
      expect(image_create).to receive(:execute)
      AwsHelpers::EC2.new.image_create(image_name, instance_id, tags)
    end

  end

  describe '#images_delete' do

    let(:images_delete) { double(ImagesDelete) }

    let(:hours) { 1 }
    let(:days) { 2 }
    let(:months) { 3 }
    let(:years) { 4 }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(ImagesDelete).to receive(:new).and_return(images_delete)
      allow(images_delete).to receive(:execute)
    end

    subject { AwsHelpers::EC2.new.images_delete(image_name, hours: hours, days: days, months: months, years: years) }

    it 'should create ImagesDelete with parameters' do
      expect(ImagesDelete).to receive(:new).with(config, image_name, hours: hours, days: days, months: months, years: years)
      subject
    end

    it 'should call ImagesDelete execute method' do
      expect(images_delete).to receive(:execute)
      subject
    end

  end


  describe '#images_delete_by_time' do

    let(:images_delete_by_time) { double(ImagesDeleteByTime) }

    let(:time) { Time.parse('01-Jan-2015') }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(ImagesDeleteByTime).to receive(:new).with(anything, anything, anything).and_return(images_delete_by_time)
      allow(images_delete_by_time).to receive(:execute)
    end

    subject { AwsHelpers::EC2.new.images_delete_by_time(image_name, time) }

    it 'should create ImagesDeleteByTime with default parameters' do
      expect(ImagesDeleteByTime).to receive(:new).with(config, image_name, time)
      subject
    end

    it 'should call ImagesDeleteByTime execute method' do
      expect(images_delete_by_time).to receive(:execute)
      subject
    end

  end

  describe '#images_find_by_tags' do

    let(:images_find_by_tags) { double(ImagesFindByTags) }
    let(:tags) { %w('tag1', 'tag2') }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(ImagesFindByTags).to receive(:new).with(anything, anything).and_return(images_find_by_tags)
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

    let(:instance_create) { double(InstanceCreate) }
    let(:image_id) { 'image_id' }
    let(:min_count) { 1 }
    let(:max_count) { 1 }
    let(:monitoring) { true }
    let(:options) { { min_count: min_count, max_count: max_count, monitoring: monitoring } }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(instance_create).to receive(:execute)
      allow(InstanceCreate).to receive(:new).and_return(instance_create)
    end

    subject { AwsHelpers::EC2.new.instance_create(image_id, options) }

    it 'should create InstanceCreate' do
      expect(InstanceCreate).to receive(:new).with(config, image_id, options).and_return(instance_create)
      subject
    end

    it 'should call InstanceCreate execute method' do
      expect(instance_create).to receive(:execute)
      subject
    end

  end

  describe '#instance_start' do

    let(:instance_start) { double(InstanceStart) }
    let(:image_id) { 'image_id' }

    let(:options) { {} } #just use defaults

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(instance_start).to receive(:execute)
      allow(InstanceStart).to receive(:new).with(config, image_id, options).and_return(instance_start)
    end

    subject { AwsHelpers::EC2.new.instance_start(image_id, options) }

    it 'should create InstanceStart' do
      expect(InstanceStart).to receive(:new).with(config, image_id, options).and_return(instance_start)
      subject
    end

    it 'should call InstanceStart execute method' do
      expect(instance_start).to receive(:execute)
      subject
    end

  end

  describe '#instance_stop' do

    let(:instance_stop) { double(InstanceStop) }
    let(:image_id) { 'image_id' }

    let(:options) { {} } #just use defaults

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(instance_stop).to receive(:execute)
      allow(InstanceStop).to receive(:new).with(config, image_id, options).and_return(instance_stop)
    end

    subject { AwsHelpers::EC2.new.instance_stop(image_id, options) }

    it 'should create InstanceStop' do
      expect(InstanceStop).to receive(:new).with(config, image_id, options).and_return(instance_stop)
      subject
    end

    it 'should call InstanceStop execute method' do
      expect(instance_stop).to receive(:execute)
      subject
    end

  end

  describe '#instances_find_by_tags' do

    let(:instances_find_by_tags) { double(InstancesFindByTags) }
    let(:tags) { %w('tag1', 'tag2') }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(InstancesFindByTags).to receive(:new).with(anything, anything).and_return(instances_find_by_tags)
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

    let(:instances_find_by_ids) { double(InstancesFindByIds) }
    let(:ids) { %w('id1', 'id2') }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(InstancesFindByIds).to receive(:new).with(anything, anything).and_return(instances_find_by_ids)
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

    let(:instance_terminate) { double(InstanceTerminate) }
    let(:image_id) { 'image_id' }

    let(:options) { {} } #just use defaults

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(instance_terminate).to receive(:execute)
      allow(InstanceTerminate).to receive(:new).with(config, image_id).and_return(instance_terminate)
    end

    subject { AwsHelpers::EC2.new.instance_terminate(image_id) }

    it 'should create InstanceTerminate' do
      expect(InstanceTerminate).to receive(:new).with(config, image_id).and_return(instance_terminate)
      subject
    end

    it 'should call InstanceTerminate execute method' do
      expect(instance_terminate).to receive(:execute)
      subject
    end

  end

  describe '#poll_instance_healthy' do

    let(:poll_inst_healthy) { double(PollInstanceHealthy) }
    let(:image_id) { 'image_id' }

    let(:options) { {} } #just use defaults

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(poll_inst_healthy).to receive(:execute)
      allow(PollInstanceHealthy).to receive(:new).with(config, image_id, options).and_return(poll_inst_healthy)
    end

    subject { AwsHelpers::EC2.new.poll_instance_healthy(image_id, options) }

    it 'should create PollInstanceHealthy' do
      expect(PollInstanceHealthy).to receive(:new).with(config, image_id, options).and_return(poll_inst_healthy)
      subject
    end

    it 'should call PollInstanceHealthy execute method' do
      expect(poll_inst_healthy).to receive(:execute)
      subject
    end

  end

  describe '#poll_instance_stopped' do

    let(:poll_inst_stopped) { double(PollInstanceStopped) }
    let(:image_id) { 'image_id' }

    let(:options) { {} } #just use defaults

    before(:each) do
      allow(poll_inst_stopped).to receive(:execute)
      allow(PollInstanceStopped).to receive(:new).with(image_id, options).and_return(poll_inst_stopped)
    end

    subject { AwsHelpers::EC2.new.poll_instance_stopped(image_id, options) }

    it 'should create PollInstanceStopped' do
      expect(PollInstanceStopped).to receive(:new).with(image_id, options).and_return(poll_inst_stopped)
      subject
    end

    it 'should call PollInstanceStopped execute method' do
      expect(poll_inst_stopped).to receive(:execute)
      subject
    end

  end

end
