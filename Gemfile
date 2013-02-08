source 'http://rubygems.org'

gem 'rails', '3.2.11'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~>3.2.2'
  gem 'uglifier', '~>1.3.0'
end

gem 'jquery-rails', '~>2.2.0'
gem "raphael-rails", "~>2.1.1"
gem 'haml-rails', '~>0.3.5'
gem 'devise', '~>2.2.3'
gem 'rails_admin', '~>0.4.3'
gem 'thin', '~>1.5.0'
gem 'airbrake', '~>3.1.7'
gem 'redis', '~>3.0.2'
gem 'parse_p1', '0.0.5'

gem 'formtastic', '~> 2.2.1'
gem 'formtastic-bootstrap', '~>2.0.0'

#heroku
group :production do
  gem 'pg', '~>0.14.1'
  gem 'newrelic_rpm', '~>3.5.6.46'
end

group :test, :development do
  gem 'pry'
  gem 'steak'
  gem 'email_spec'
  gem 'shoulda-matchers'
  gem 'mocha'
  gem 'guard'
  gem 'guard-rspec'
  gem 'rb-fsevent'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'spork'
  gem 'spork-rails'

  #see https://github.com/guard/guard-spork/issues/107, should be fixed in 1.4.2 (not available yet because of rubygems hack)
  gem 'guard-spork', github: 'guard/guard-spork' #see https://github.com/guard/guard-spork/issues/107

  gem 'database_cleaner'
  gem 'pg', '~>0.14.1'
  gem 'taps'
  gem 'sqlite3'
  gem 'mysql2'
end

