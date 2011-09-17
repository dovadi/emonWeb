source 'http://rubygems.org'

gem 'rails', '3.1.1.rc1'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'haml-rails'
gem 'devise'
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'

#heroku
group :production do
  gem 'pg'
end

group :test, :development do
  gem 'steak'
  gem 'email_spec'
  gem 'shoulda'
  gem 'guard'
  gem 'guard-rspec'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'rb-fsevent'
  gem 'growl_notify'
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

