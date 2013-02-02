require 'rubygems'
require 'spork'

def drop_table(name)
  sql = "DROP TABLE IF EXISTS #{name}"
  ActiveRecord::Base.connection.execute(sql)
end

def drop_data_stores
  ActiveRecord::Base.connection.tables.each do |table_name|
    drop_table(table_name) if table_name =~/data_store_/
  end
end

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  # This file is copied to spec/ when you run 'rails generate rspec:install'

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)
  Spork.trap_class_method(RailsAdmin, :config)

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

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end


    config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    # config.mock_with :rspec

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

end

Spork.each_run do
  # This code will be run each time you run your specs.
  FactoryGirl.reload
end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.




