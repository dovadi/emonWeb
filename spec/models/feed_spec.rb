require File.dirname(__FILE__) + '/../spec_helper'

describe Feed do

  it 'should be valid' do
    @feed = Feed.create!(:last_value => 252.55, :name => 'electra', :input_id => 3)
    @feed.should be_valid
  end

  it { should belong_to :input}

  describe 'Processing of data' do  

    before(:each) do
      @attr = {
        :last_value => 252.55,
        :user_id    => 100,
        :input_id   => 1,
        :processors => [[:scale, 1.23], [:offset, 3.5]]
      }
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
      Feed.create!(@attr)
      Feed.last.last_value.should == 1546.34
    end
  end

  describe 'Process of data with an undefined processor' do
    before(:each) do
      @attr = {
        :last_value => 252.55,
        :user_id    => 100,
        :input_id   => 1,
        :processors => [[:unknown, 3.5]]
      }
    end
    it 'should raise an UndefinedProcessor expection' do
      expect do
        Feed.create!(@attr)
      end.to raise_error UndefinedProcessorException
    end
  end

end
