require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'active_resource/railtie'
require 'sprockets/railtie'
require File.expand_path(File.dirname(__FILE__) + '/../vendor/plugins/api-throttling/lib/api_throttling')

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

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    #API throttle: enforcing a minimum 8-second interval between requests
    cache = ActiveSupport::Cache::MemoryStore.new
    config.middleware.use ApiThrottling, :min => 8.0, :auth=>false, :cache => cache, :urls => ['POST /api']
  end
end
