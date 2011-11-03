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

  describe 'Process of data' do
    before(:each) do
      @attr.merge!(:processors => {:multiply =>[2], :divide => [3]})
      @processor_klass = mock
      String.any_instance.expects(:constantize).twice.returns(@processor_klass)
    end

    it 'should perform the given processors' do
      processor = mock
      processor.stubs(:perform)
      @processor_klass.expects(:new).with(252.55, [2]).returns(processor)
      @processor_klass.expects(:new).with(252.55, [3]).returns(processor)
      Feed.create!(@attr)
    end

  end
end
