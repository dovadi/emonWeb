describe GasStorageProcessor do

  it 'should tell data should be stored' do
    GasStorageProcessor.store?.should == true
  end

  it 'should tell its description' do
    GasStorageProcessor.description.should == 'Deprecated'
  end

  it 'should only pass the value during a perform' do
    DataStore.should_receive(:create).never
    Feed.should_receive(:update).never
    processor = GasStorageProcessor.new(98.76, 12345)
    processor.perform.should == 98.76
  end

end
