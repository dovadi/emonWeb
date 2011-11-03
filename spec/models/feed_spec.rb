require File.dirname(__FILE__) + '/../spec_helper'

describe Feed do

  before(:each) do
    @attr = { 
      :value   => 252.55,
      :user_id => 100,
      :input_id => 1
    }
  end

  it { should belong_to :user }
  it { should belong_to :input }

  it 'should be valid' do
    @feed = Feed.create!(@attr)
    @feed.should be_valid
  end

  describe 'Process of data in case of two seperate processor' do
    before(:each) do
      @attr.merge!(:processors => [{:multiply => [2]}, {:divide => [3]}])
      @processor_klass = mock
      String.any_instance.expects(:constantize).twice.returns(@processor_klass)
    end

    it 'should perform the given processors' do
      multiply_processor = mock
      multiply_processor.stubs(:perform).returns(500)
      divide_processor = mock
      divide_processor.stubs(:perform).returns(123.45)

      @processor_klass.expects(:new).with(252.55, [2]).returns(multiply_processor)
      @processor_klass.expects(:new).with(252.55, [3]).returns(divide_processor)
      Feed.create!(@attr)
      Feed.last.processed_value_0.should == 500
      Feed.last.processed_value_1.should == 123.45
    end
  end

  describe 'Process of data in case of two processor in serial' do
    before(:each) do
      @attr.merge!(:processors => [{:multiply => [2], :divide => [3]}])
      @processor_klass = mock
      String.any_instance.expects(:constantize).twice.returns(@processor_klass)
    end

    it 'should perform the given processors' do
      processor = mock
      processor.stubs(:perform).returns(500)
      @processor_klass.expects(:new).with(252.55, [2]).returns(processor)
      @processor_klass.expects(:new).with(500, [3]).returns(processor)
      Feed.create!(@attr)
      Feed.last.processed_value_0.should == 500
    end
  end

  describe 'Process of data with an undefined processor' do
    before(:each) do
      @attr.merge!(:processors => [:unknown_processor => [2]])
    end
    it 'should raise an UndefinedProcessor expection' do
      expect do
        Feed.create!(@attr)
      end.to raise_error UndefinedProcessor
    end
  end

end
