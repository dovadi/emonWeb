describe PowerToKwhPerDayProcessor do

  it 'should tell data should be stored' do
    PowerToKwhPerDayProcessor.store?.should == true
  end

  it 'should tell its description' do
    PowerToKwhPerDayProcessor.description.should == 'Power to kWh/d'
  end

  describe 'Calculate value for the first time' do
    before(:each) do
      @feed = Feed.create(:last_value => nil, :user_id => 1, :input_id => 1)
    end

    it 'should store the data in the corresponding DataStore table' do
      arel_object  = mock
      arel_object.expects(:first).returns(nil)

      scope_object = mock
      scope_object.expects(:where).with(:created_at => Date.today).returns(arel_object)

      DataStore.stubs(:from).with('data_store_' + @feed.id.to_s).returns(scope_object)
      DataStore.expects(:create).with(:value => 0, :identified_by => @feed.id, :created_at => Date.today)
      Feed.expects(:update).with(@feed.id, :last_value => 0)

      processor = PowerToKwhPerDayProcessor.new(3600, @feed.id)
      processor.perform.should == 3600
      processor.value.should == 0
    end
  end

  describe 'Calculate value during the day' do
    before(:each) do
      @feed = Feed.create(:last_value => nil, :user_id => 1, :input_id => 1)
    end

    it 'should store the data in the corresponding DataStore table' do
      data_store   = mock
      data_store.expects(:update_attributes).with(:value => 0.1, :identified_by => @feed.id, :created_at => Date.today)
      Feed.expects(:update).with(@feed.id, :last_value => 0.1)

      arel_object  = mock
      arel_object.expects(:first).returns(data_store)

      scope_object = mock
      scope_object.expects(:where).with(:created_at => Date.today).returns(arel_object)

      DataStore.stubs(:from).with('data_store_' + @feed.id.to_s).returns(scope_object)

      Time.stubs(:now).returns(Time.at(1320857865))
      Feed.any_instance.stubs(:updated_at).returns(Time.now - 100.seconds)

      processor = PowerToKwhPerDayProcessor.new(3600, @feed.id)
      processor.perform.should == 3600
      processor.value.should == 0.1
    end
  end

end
