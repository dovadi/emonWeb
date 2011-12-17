require File.dirname(__FILE__) + '/../spec_helper'

describe Input do

  before(:each) do
    @attr = { :name => 'water', :last_value => 252.55 }
    Input.delete_all
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :last_value }
  it { should belong_to :user }
  it { should have_many :feeds }

  it 'should only accept an unique name' do
    Input.create!(@attr)
    Input.new.should validate_uniqueness_of(:name).scoped_to(:user_id)
  end

  it 'should create a new instance given a valid attribute' do
    Input.create!(@attr)
  end

  describe 'Create or Update' do
    before(:each) do
      @input_attrs = { :water => 20.45, :solar => 12.34, :user_id => 100 }
    end

    it 'should raise an exception if user_id is not given' do
      expect do
        Input.create_or_update(:heat => 56)
      end.to raise_error NoUserIdGiven
    end

    it 'should create or update an input based on the given attributes' do
      expect do
        Input.create_or_update(@input_attrs)
      end.to change(Input, :count).by(2)
      Input.last.user_id.should == 100
    end

    it 'should create or update an input based on the given attributes but ignore controller and action keys' do
      expect do
        Input.create_or_update(@input_attrs.merge(:controller => 'inputs', :action => 'create', :auth_token => 'ej24retn0'))
      end.to change(Input, :count).by(2)
    end

    describe 'For only non-existant input' do
      before(:each) do
        Input.create!(@attr.merge(:user_id => 100))
      end
      it 'should create the input that does not exist yet' do
        expect do
          Input.create_or_update(@input_attrs)
        end.to change(Input, :count).by(1)
      end
    end

    it 'should update the last value if input already exists' do
      input = Input.create!(@attr.merge(:user_id => 100))
      Input.create_or_update(@input_attrs)
      input.reload
      input.last_value.should == 20.45
    end

    it 'should update the last value if input already exists and the last value is the same' do
      input = Input.create!(@attr.merge(:user_id => 100))
      Input.any_instance.expects(:touch).with(:updated_at)
      Input.create_or_update(:water => 252.55, :user_id => 100)
    end
  end

  describe 'With processors' do

    def drop_data_stores
      ActiveRecord::Base.connection.tables.each do |table_name|
        drop_table(table_name) if table_name =~/data_store_/
      end
    end

    def verify_table(table_name)
      DataStore.from(table_name).count.should == 0
      DataStoreSql::TIMESLOTS.each do |timeslot|
        DataStore.from(table_name + '_' + timeslot.to_s).count.should == 0
      end
    end

    before(:each) do
      drop_data_stores
      @input = Input.create!(@attr.merge(:user_id => 3))
      @input.define_processor!(:log_to_feed, 'kWh')
      @input.define_processor!(:scale, 1.23) 
      @input.define_processor!(:offset, 2.5)
      @input.define_processor!(:power_to_kwh, 'Calibrated kWh')
      @input.define_processor!(:power_to_kwh_per_day, 'kWh/d')
      @last_feed = Feed.last
    end

    it 'should create the corresponding feeds' do
      @input.feeds.count.should == 3
    end

    it 'should assign correct user to the feed' do
      @last_feed.user_id.should == @input.user_id
    end

    it 'should define the processors' do
      @input.processors.should == [[:log_to_feed, @last_feed.id - 2],[:scale, 1.23], [:offset, 2.5],[:power_to_kwh, @last_feed.id - 1], [:power_to_kwh_per_day, @last_feed.id]]
    end

    it 'should have created the corresponding data stores with corresponding timeslots' do
      verify_table('data_store_' + (@last_feed.id - 2).to_s)
      verify_table('data_store_' + (@last_feed.id - 1).to_s)
      verify_table('data_store_' + (@last_feed.id - 0).to_s)
    end

    it 'should update the last value of the corresponding feeds' do
      Feed.expects(:update).with(@last_feed.id - 2, any_parameters)
      Feed.expects(:update).with(@last_feed.id - 1, any_parameters)
      Feed.expects(:update).with(@last_feed.id    , any_parameters)
      Input.create_or_update(:water => 255.12, :user_id => 3)
    end

    describe 'Process of data with an undefined processor' do
      before(:each) do
          @attr = {
          :last_value => 252.55,
          :name       => 'heat',
          :user_id    => 100,
          :processors => [[:unknown, 3.5]]
        }
        Input.create!(@attr)
      end
      it 'should raise an UndefinedProcessor expection' do
        expect do
          Input.create_or_update(:heat => 252.55, :user_id => 100)
        end.to raise_error UndefinedProcessorException
      end
    end

    describe 'Processing of data' do

      before(:each) do
        @attr = {
          :last_value => 252.55,
          :name       => 'heat',
          :user_id    => 100,
          :processors => [[:scale, 1.23], [:offset, 3.5]]
        }
        Input.create!(@attr)
        @processor_klass = mock
        String.any_instance.expects(:constantize).twice.returns(@processor_klass)
      end

      it 'should perform the given processors' do
        scale_processor = mock
        scale_processor.stubs(:perform).returns(500)
        offset_processor = mock
        offset_processor.stubs(:perform).returns(1546.34)
        @processor_klass.expects(:new).with(252.55, 1.23).returns(scale_processor)
        @processor_klass.expects(:new).with(500, 3.5).returns(offset_processor)
        Input.create_or_update(:heat => 252.55, :user_id => 100)
      end
    end

  end

end