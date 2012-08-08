source 'http://rubygems.org'

gem 'rails', '3.2.8.rc2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~>3.2.2'
  gem 'uglifier', '~>1.2.4'
end

gem 'jquery-rails', '~>2.0.2'
gem 'haml-rails', '~>0.3.4'
gem 'devise', '~>2.1.0'
gem 'rails_admin', '~>0.0.5'
gem 'thin', '~>1.4.1'
gem 'airbrake', '~>3.1.2'
gem 'redis', '~>3.0.0'
gem 'parse_p1', '0.0.5'

#TODO Formtastic not yet able to update because of Rails '~>3.1.0' dependency
gem 'formtastic', '~> 2.1.1'
gem 'formtastic-bootstrap', '~>1.1.1'

#heroku
group :production do
  gem 'pg', '~>0.14.0'
  gem 'newrelic_rpm', '~>3.4.1'
end

group :test, :development do
  gem 'steak', '~>2.0.0'
  gem 'email_spec', '~>1.2.1'
  gem 'shoulda-matchers', '~>1.2.0'
  gem 'mocha', '~>0.12.3'
  gem 'guard', '~>1.3.0'
  gem 'guard-rspec', '~>1.2.1'
  gem 'factory_girl', '~>4.0.0'
  gem 'factory_girl_rails', '~>4.0.0'
  gem 'spork', '~>1.0.0rc2'
  gem 'spork-rails', '~>3.2.0'
  gem 'guard-spork', '~>1.1.0'
  gem 'database_cleaner', '~>0.8.0'
  gem 'pg', '~>0.14.0'
  gem 'taps', '~>0.3.24'
  gem 'sqlite3', '~>1.3.6' #Specificly needed for taps
  #gem 'mysql2'
end

