describe LogToFeedProcessor do
  it 'should tell data should be stored' do
    LogToFeedProcessor.store?.should == true
  end

  it 'should tell its description' do
    LogToFeedProcessor.description.should == 'Log to Feed'
  end

  it 'should store the data in the corresponding DataStore table' do
    DataStore.expects(:create).with(:value => 123.45, :identified_by => 3)
    processor = LogToFeedProcessor.new(123.45, 3)
    processor.perform
  end
end
