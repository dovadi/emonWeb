source 'http://rubygems.org'

gem 'rails', '3.2.13'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'raphael-rails'
gem 'haml-rails'
gem 'devise'
gem 'rails_admin'
gem 'thin'
gem 'airbrake'
gem 'redis'
gem 'parse_p1'
gem 'nokogiri', '1.5.0' #1.5.6 and higher gave ruby bug errors

gem 'formtastic'
gem 'formtastic-bootstrap'

#heroku
group :production do
  gem 'pg', '~>0.14.1'
  gem 'newrelic_rpm'
end

group :test, :development do
  gem 'rspec'
  gem 'pry'
  gem 'steak'
  gem 'email_spec'
  gem 'shoulda-matchers'
  gem 'guard'
  gem 'guard-rspec'
  gem 'rb-fsevent'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'zeus'
  gem 'guard-zeus'
  gem 'database_cleaner'
  gem 'pg', '~>0.14.1'
  gem 'taps'
  gem 'sqlite3'
  gem 'mysql2'
end

