describe DifferenceProcessor do
  it 'should tell data should be stored' do
    DifferenceProcessor.store?.should == true
  end

  it 'should tell its description' do
    DifferenceProcessor.description.should == 'Only store the value is different than last one'
  end

  describe 'perfom' do
    before(:each) do
      @feed = Feed.create!(:last_value => 252.55, :name => 'electra', :input_id => 3, :user_id => 1)
    end

    it 'should only store the value is different than last one' do
      processor = DifferenceProcessor.new(252.76, @feed.id)
      DataStore.expects(:create).with(:value => 0.21, :identified_by => @feed.id)
      Feed.expects(:update).with(@feed.id, :last_value => 252.76)
      processor.perform.should == 0.21
    end

    it 'should not store the value it is the same as the last one' do
      DataStore.expects(:create).never
      Feed.expects(:update).never
      processor = DifferenceProcessor.new(252.55, @feed.id)
      processor.perform.should == 0.0
    end

    it 'should store the value for the very first time' do
      @feed.destroy
      @feed = Feed.create!(:last_value => nil, :name => 'electra', :input_id => 3, :user_id => 1)
      DataStore.expects(:create).with(:value => 252.76, :identified_by => @feed.id)
      Feed.expects(:update).with(@feed.id, :last_value => 252.76)
      processor = DifferenceProcessor.new(252.76, @feed.id)
      processor.perform.should == 252.76
    end

  end

end