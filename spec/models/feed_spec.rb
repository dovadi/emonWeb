require File.dirname(__FILE__) + '/../spec_helper'

describe Feed do

  it 'should be valid' do
    @feed = Feed.create!(:value   => 252.55)
    @feed.should be_valid
  end

  describe 'Feed assigned to table with a suffix based on a identifier' do
    before(:each) do
      @attr = {:value => 252.55, :identified_by => '236'}
    end

    it 'should set the correct table_name' do
      Feed.expects(:table_name=).with('feed_236')
      Feed.expects(:table_name=).with('feeds')
      Feed.create(@attr)
    end

    it 'should really create a new table in the database if not existed yet' do
      sql = "DROP TABLE IF EXISTS `feed_236`"
      ActiveRecord::Base.connection.execute(sql)
      begin
        Feed.create!(@attr)
      rescue ActiveRecord::StatementInvalid
        # Prevent throwing Mysql2::Error: SAVEPOINT active_record_1 does not exist: ROLLBACK TO SAVEPOINT active_record_1
        # after creating the new feed table rollback is not possible because
        # it is loosing its savepoint because of execution of raw sql to create a new table
      end
      Feed.from('feed_236').first.value.should == 252.55
      ActiveRecord::Base.connection.execute(sql)
    end

  end

end
