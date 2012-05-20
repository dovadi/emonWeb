describe GasStorageProcessor do

  it 'should tell data should be stored' do
    GasStorageProcessor.store?.should == true
  end

  it 'should tell its description' do
    GasStorageProcessor.description.should == 'Store gas usage'
  end
  
  #Gas usage is allways stored before gas_last_reading
  describe 'Saving' do
    before do
      @user        = User.create!(:email => 'user@example.com', :password => 'foobar', :password_confirmation => 'foobar')
      @gas_usage   = Input.create!(:name => 'gas_usage', :last_value => 123.45, :user_id => @user.id)

      # Force difference in ids between @gas_usage and @feed by creating an extra dummy feed, so they will be 1 and 2 instead of 1 and 1
      Feed.create!(:last_value => 123.45, :name => 'dummy', :input_id => @gas_usage.id, :user_id => @user.id)

      @feed        = Feed.create!(:last_value => 123.45, :name => 'gas_usage', :input_id => @gas_usage.id, :user_id => @user.id)
      @gas_last_reading = Time.now.to_f
    end

    it 'Gas usage should store its data for the first time' do
      DataStore.expects(:create).with(:value => 123.45, :identified_by => @feed.id)
      Feed.expects(:update).with(@feed.id, :last_value => @gas_last_reading)
      processor = GasStorageProcessor.new(@gas_last_reading, @feed.id)
      processor.perform.should == @gas_last_reading
    end

    describe 'Gas usage' do
      before do
        @last_time = @gas_last_reading - 10
        Input.create!(:name => 'gas_last_reading', :last_value => @last_time , :user_id => @user.id)
      end

      it 'should not store its data if last reading was less than one hour ago' do
        DataStore.count.should == 0
        Feed.expects(:update).with(@feed.id, :last_value => @gas_last_reading)
        processor = GasStorageProcessor.new(@gas_last_reading, @feed.id)
        processor.perform.should == @gas_last_reading
      end
    end

    describe 'Gas usage' do
      before do
        @last_time = @gas_last_reading - 3601
        Input.create!(:name => 'gas_last_reading', :last_value => @last_time , :user_id => @user.id)
      end

      it 'should store its data if last reading was more than one hour ago' do
        DataStore.expects(:create).with(:value => 123.45, :identified_by => @feed.id)
        Feed.expects(:update).with(@feed.id, :last_value => @gas_last_reading)
        processor = GasStorageProcessor.new(@gas_last_reading, @feed.id)
        processor.perform.should == @gas_last_reading
      end
    end
  end

  describe 'Saving' do
    before do
      @user        = User.create!(:email => 'user@example.com', :password => 'foobar', :password_confirmation => 'foobar')
      @gas_usage   = Input.create!(:name => 'gas_usage', :last_value => 123.45, :user_id => @user.id)
      @feed        = Feed.create!(:last_value => 123.45, :name => 'gas_usage', :input_id => @gas_usage.id, :user_id => 3)
      @gas_last_reading = Time.now.to_f
    end

    describe 'Gas usage' do
      before do
        @last_time = @gas_last_reading - 3601
        Input.create!(:name => 'gas_last_reading', :last_value => @last_time , :user_id => @user.id)
      end

      it 'should not store its data from different users' do
        DataStore.count.should == 0
        Feed.expects(:update).with(@feed.id, :last_value => @gas_last_reading)
        processor = GasStorageProcessor.new(@gas_last_reading, @feed.id)
        processor.perform.should == @gas_last_reading
      end
    end
  end

end
