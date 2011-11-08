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

  # describe 'Process of data in case of two seperate processor' do
  #   before(:each) do
  #     @attr.merge!(:processors => [{:multiply => [2]}, {:divide => [3]}])
  #     @processor_klass = mock
  #     String.any_instance.expects(:constantize).twice.returns(@processor_klass)
  #   end
  # 
  #   it 'should perform the given processors' do
  #     multiply_processor = mock
  #     multiply_processor.stubs(:perform).returns(500)
  #     divide_processor = mock
  #     divide_processor.stubs(:perform).returns(123.45)
  # 
  #     @processor_klass.expects(:new).with(252.55, [2]).returns(multiply_processor)
  #     @processor_klass.expects(:new).with(252.55, [3]).returns(divide_processor)
  #     Feed.create!(@attr)
  #     Feed.last.processed_value_0.should == 500
  #     Feed.last.processed_value_1.should == 123.45
  #   end
  # end

  # describe 'Process of data in case of two processor in serial' do
  #   before(:each) do
  #     @attr.merge!(:processors => [{:multiply => [2], :divide => [3]}])
  #     @processor_klass = mock
  #     String.any_instance.expects(:constantize).twice.returns(@processor_klass)
  #   end
  # 
  #   it 'should perform the given processors' do
  #     processor = mock
  #     processor.stubs(:perform).returns(500)
  #     @processor_klass.expects(:new).with(252.55, [2]).returns(processor)
  #     @processor_klass.expects(:new).with(500, [3]).returns(processor)
  #     Feed.create!(@attr)
  #     Feed.last.processed_value_0.should == 500
  #   end
  # end
  # 
  # describe 'Process of data with an undefined processor' do
  #   before(:each) do
  #     @attr.merge!(:processors => [:unknown_processor => [2]])
  #   end
  #   it 'should raise an UndefinedProcessor expection' do
  #     expect do
  #       Feed.create!(@attr)
  #     end.to raise_error UndefinedProcessor
  #   end
  # end

end
