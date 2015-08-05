require 'aws_helpers/ec2'

describe AwsHelpers::EC2 do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(AwsHelpers::Config) }
  let(:image_name) { 'ec2_name' }

  describe '#initialize' do

    it 'should call AwsHelpers::Client initialize method' do
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::EC2.new(options)
    end

  end

  describe '#image_create' do

    let(:image_create) { double(ImageCreate) }

    let(:instance_id) { 'ec2_id' }
    let(:default_tags) { %w() }
    let(:additional_tags) { %w('tag1', 'tag2') }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(ImageCreate).to receive(:new).with(anything, anything, anything, anything).and_return(image_create)
      allow(image_create).to receive(:execute)
    end

    it 'should create ImageCreate with default parameters' do
      expect(ImageCreate).to receive(:new).with(config, image_name, instance_id, default_tags)
      AwsHelpers::EC2.new(options).image_create(name: image_name, instance_id: instance_id, additional_tags: default_tags)
    end

    it 'should call ImageCreate execute method' do
      expect(image_create).to receive(:execute)
      AwsHelpers::EC2.new(options).image_create(name: image_name, instance_id: instance_id, additional_tags: default_tags)
    end

    context 'call ImageCreate with additional_tags' do

      it 'should create ImageCreate with additional tags' do
        expect(ImageCreate).to receive(:new).with(config, image_name, instance_id, additional_tags)
        AwsHelpers::EC2.new(options).image_create(name: image_name, instance_id: instance_id, additional_tags: additional_tags)
      end

    end

  end

  describe '#images_delete' do

    let(:images_delete) { double(ImagesDelete) }

    let(:default_days) { nil }
    let(:default_months) { nil }
    let(:default_years) { nil }

    let(:days) { 1 }
    let(:months) { 1 }
    let(:years) { 1 }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(ImagesDelete).to receive(:new).with(anything, anything, anything, anything, anything).and_return(images_delete)
      allow(images_delete).to receive(:execute)
    end

    subject { AwsHelpers::EC2.new(options).images_delete(name: image_name) }

    it 'should create ImagesDelete with default parameters' do
      expect(ImagesDelete).to receive(:new).with(config, image_name, default_days, default_months, default_years)
      subject
    end

    it 'should call ImagesDelete execute method' do
      expect(images_delete).to receive(:execute)
      subject
    end

    it 'should calls ImagesDelete with days supplied' do
      expect(ImagesDelete).to receive(:new).with(config, image_name, days, nil, nil)
      AwsHelpers::EC2.new(options).images_delete(name: image_name, days: days, months: default_months, years: default_years)
    end

    it 'should calls ImagesDelete with months supplied' do
      expect(ImagesDelete).to receive(:new).with(config, image_name, nil, months, nil)
      AwsHelpers::EC2.new(options).images_delete(name: image_name, days: default_days, months: months, years: default_years)
    end

    it 'should calls ImagesDelete with years supplied' do
      expect(ImagesDelete).to receive(:new).with(config, image_name, nil, nil, years)
      AwsHelpers::EC2.new(options).images_delete(name: image_name, days: default_days, months: default_months, years: years)
    end

    it 'should calls ImagesDelete with days, months and years supplied' do
      expect(ImagesDelete).to receive(:new).with(config, image_name, days, months, years)
      AwsHelpers::EC2.new(options).images_delete(name: image_name, days: days, months: months, years: years)
    end

  end


  describe '#images_delete_by_time' do

    let(:images_delete_by_time) { double(ImagesDeleteByTime) }

    let(:time) { Time.local(2000, 'jan', 1, 20, 15, 1) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(ImagesDeleteByTime).to receive(:new).with(anything, anything, anything).and_return(images_delete_by_time)
      allow(images_delete_by_time).to receive(:execute)
    end

    subject { AwsHelpers::EC2.new(options).images_delete_by_time(name: image_name, time: time) }

    it 'should create ImagesDeleteByTime with default parameters' do
      expect(ImagesDeleteByTime).to receive(:new).with(config, image_name, time)
      subject
    end

    it 'should call ImagesDeleteByTime execute method' do
      expect(images_delete_by_time).to receive(:execute)
      subject
    end

  end


  describe '#images_find_by_tag' do

    let(:images_find_by_tag) { double(ImagesFindByTag) }
    let(:tag) { double(:tag, name: 'name', values: [ 'a_value', 'another_value' ] ) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(ImagesFindByTag).to receive(:new).with(anything, anything).and_return(images_find_by_tag)
      allow(images_find_by_tag).to receive(:execute)
    end

    subject { AwsHelpers::EC2.new(options).images_find_by_tag(tag: tag) }

    it 'should create ImagesFindByTag' do
      expect(ImagesFindByTag).to receive(:new).with(config, tag)
      subject
    end

    it 'should call ImagesFindByTag execute method' do
      expect(images_find_by_tag).to receive(:execute)
      subject
    end

  end


end
