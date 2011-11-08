require File.dirname(__FILE__) + '/../spec_helper'

describe Input do

  before(:each) do
    @attr = { 
      :name       => 'water',
      :last_value => 252.55
    }
    Input.delete_all
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :last_value }
  it { should belong_to :user }

  it 'should only accept an unique name' do
    Input.create!(@attr)
    Input.new.should validate_uniqueness_of(:name).scoped_to(:user_id)
  end

  it 'should create a new instance given a valid attribute' do
    Input.create!(@attr)
  end

  describe 'Define processors' do
    before(:each) do
      drop_table('feed_2')
      @processors = [[:log_to_feed, 2], [:scale, 1.32], [:offset, 4]] 
                    #[:power_to_kwh, 3], [:power_to_kwh_per_day, 4], [:x_input, 3]]
      @attr.merge!(:processors => @processors)
    end

    it 'should serialize and store processors' do
      suppress_savepoint_error { Input.create!(@attr) }
      Input.last.processors.should == @processors
    end

    it 'should create a new feed table if not exist yet' do
      suppress_savepoint_error { Input.create!(@attr) }
      Feed.from('feed_2').count == 0
    end

    after(:each) do
      drop_table('feed_2')
    end
  end

  describe 'Create or Update' do
    before(:each) do
      @input_attrs ={
        :water   => 20.45,
        :solar   => 12.34,
        :user_id => 100
      }
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

end