describe PowerToKwhProcessor do

  before(:each) do
    @feed = Feed.create(:last_value => nil, :user_id => 1, :input_id => 1)
  end

  it 'should tell data should be stored' do
    PowerToKwhProcessor.store?.should == true
  end

  it 'should tell its description' do
    PowerToKwhProcessor.description.should == 'Power to kWh'
  end

  it 'should store the data in the corresponding DataStore table' do
    Time.stubs(:now).returns(Time.at(1320857865))
    Feed.any_instance.stubs(:updated_at).returns(Time.now - 100.seconds)
    DataStore.expects(:create).with(:value => 0.1, :identified_by => @feed.id)
    processor = PowerToKwhProcessor.new(3600, @feed.id)
    processor.perform.should == 0.1
  end
end
