require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require 'active_record/railtie'
# require 'action_controller/railtie'
# require 'action_mailer/railtie'
# require 'active_resource/railtie'
# require 'sprockets/railtie'
require 'rails/all'
require File.expand_path(File.dirname(__FILE__) + '/../lib/api-throttling/lib/api_throttling')
require 'redis'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Emonweb
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/processors)
    config.autoload_paths << Rails.root.join('lib', 'emonweb')
    # config.autoload_paths += %W(#{config.root}/extras)
    # config.autoload_paths << Rails.root.join('vendor', 'gems', 'rack-throttle', 'lib')


    config.assets.paths << Rails.root.join('app', 'assets', 'bootstrap')
    config.assets.paths << Rails.root.join('app', 'assets', 'flot')
    config.assets.paths << Rails.root.join('app', 'assets', 'widgets')
    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run 'rake -D time' for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Amsterdam'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = 'utf-8'

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    #API throttle: enforcing a minimum 8-second interval between requests
    #if Rails.env == 'production'
      # url   = YAML.load(File.read("#{Rails.root}/config/redis.yml"))['url']
    #  uri   = URI.parse(ENV['REDIS_TO_GO_URL']) #see http://devcenter.heroku.com/articles/config-vars
    #  cache = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    #else
    #  cache = ActiveSupport::Cache::MemoryStore.new
    #end
    #config.middleware.use ApiThrottling, :min => 8.0, :auth=>false, :cache => cache, :urls => ['POST /api']
  end
end
