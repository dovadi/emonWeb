require 'rubygems'

def drop_table(name)
  sql = "DROP TABLE IF EXISTS #{name}"
  ActiveRecord::Base.connection.execute(sql)
end

def drop_data_stores
  ActiveRecord::Base.connection.tables.each do |table_name|
    drop_table(table_name) if table_name =~/data_store_/
  end
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

module ActiveRecord
  module ConnectionAdapters

    class AbstractAdapter

      #Monkey patch: don't cache database tables. DatabaseCleaner uses the double pipe / or equals (||=) operator
      #See https://github.com/bmabey/database_cleaner/blob/master/lib/database_cleaner/active_record/truncation.rb r25
      #With caching it tries to cleanup tables that doesn't exist! And we get errors like:

      #  ActiveRecord::StatementInvalid:
      #    PG::Error: ERROR:  relation "data_store_14" does not exist

      #This is because we create a lot data store table on the fly during tests
      def database_cleaner_table_cache
        @database_cleaner_tables = tables
      end

    end
  end
end

require 'rspec/rails'
require 'shoulda/matchers/integrations/rspec'

#See http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
Devise.stretches = 1
Rails.logger.level = 4

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
  config.include Devise::TestHelpers, :type => :controller
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
