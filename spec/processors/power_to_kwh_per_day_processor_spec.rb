describe PowerToKwhPerDayProcessor do

  before(:each) do
    @feed = Feed.create(:last_value => 1, :user_id => 1, :input_id => 1)
  end

  it 'should tell data should be stored' do
    PowerToKwhPerDayProcessor.store?.should == true
  end

  it 'should tell its description' do
    PowerToKwhPerDayProcessor.description.should == 'Power to kWh/d'
  end

  # it 'should store the data in the corresponding DataStore table' do
  #   Time.stubs(:now).returns(Time.at(1320857865))
  #   Feed.any_instance.stubs(:updated_at).returns(Time.now - 100.seconds)
  #   DataStore.expects(:create).with(:value => 1.1, :identified_by => @feed.id)
  #   processor = PowerToKwhProcessor.new(3600, @feed.id)
  #   processor.perform
  # end
  # 
end
