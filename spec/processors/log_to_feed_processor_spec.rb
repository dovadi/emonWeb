describe LogToFeedProcessor do
  it 'should tell data should be stored' do
    LogToFeedProcessor.store?.should == true
  end

  it 'should tell its description' do
    LogToFeedProcessor.description.should == 'Log to Feed'
  end

  it 'should store the data in the corresponding DataStore table' do
    DataStore.should_receive(:create).with(:value => 123.45, :identified_by => 3)
    Feed.should_receive(:update).with(3, :last_value => 123.45)
    processor = LogToFeedProcessor.new(123.45, 3)
    processor.perform.should == 123.45
  end
end
