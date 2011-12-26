require 'rubygems'
require 'rack'
require File.expand_path(File.dirname(__FILE__) + '/handlers/handlers')

class ApiThrottling

  def initialize(app, options={})
    @app = app
    @options = {:requests_per_hour => 60, :cache=>:redis, :auth=>true}.merge(options)
    @handler = Handlers.cache_handler_for(@options[:cache])
    raise "Sorry, we couldn't find a handler for the cache you specified: #{@options[:cache]}" unless @handler
  end

  def call(env)
    dup._call(env)
  end

  def _call(env)
    if @options[:urls]
      req = Rack::Request.new(env)
      # call the app normally cause the path restriction didn't match
      return @app.call(env) unless request_matches?(req)
    end

    if @options[:auth]
      auth = Rack::Auth::Basic::Request.new(env)
      return auth_required unless auth.provided?
      return bad_request unless auth.basic?
    end
    min_interval_allowed?(env, auth, req) ? @app.call(env) : over_rate_limit
  end

  def request_matches?(req)
    @options[:urls].any? do |url|
      "#{req.request_method} #{req.path}".match(url)
    end
  end

  #FO: Scope key by ip-adress if no auth
  def generate_key(env, auth, req)
    return @options[:key].call(env, auth) if @options[:key]
    auth ? "#{auth.username}_key" : "#{client_identifier(req)}_key"
  end

  def client_identifier(request)
    request.ip.to_s
  end

  def bad_request
    body_text = "Bad Request"
    [ 400, { 'Content-Type' => 'text/plain', 'Content-Length' => body_text.size.to_s }, [body_text] ]
  end

  def auth_required
    body_text = "Authorization Required"
    [ 401, { 'Content-Type' => 'text/plain', 'Content-Length' => body_text.size.to_s }, [body_text] ]
  end

  def over_rate_limit
    body_text = "Over Rate Limit"
    retry_after_in_seconds = (60 - Time.now.min) * 60
    [ 503, 
      { 'Content-Type' => 'text/plain', 
        'Content-Length' => body_text.size.to_s, 
        'Retry-After' => retry_after_in_seconds.to_s 
      }, 
      [body_text]
    ]
  end

  def handle_exception(exception)
    if defined?(Rails) && Rails.env.development?
      raise exception
    else
      # FIXME notify hoptoad?
    end
  end

  ##################################################
  # Interval methods copied from rack-throttle gem #
  ##################################################

  def min_interval_allowed?(env, auth, req)
    cache = @handler.new(@options[:cache])
      key   = generate_key(env, auth, req)

      t0    = cache.get(key)
      t1    = request_start_time(req)

      allowed = !t0 || (dt = t1 - t0.to_f) >= minimum_interval
      notify_via_airbrake(req) unless allowed
    begin
      cache.set(key, t1)
      allowed
    rescue => e
      # If an error occurred while trying to update the timestamp stored
      # in the cache, we will fall back to allowing the request through.
      # This prevents the Rack application blowing up merely due to a
      # backend cache server (Memcached, Redis, etc.) being offline.
      allowed = true
    end
  end

  def request_start_time(request)
    case
    when request.env.has_key?('HTTP_X_REQUEST_START')
      request.env['HTTP_X_REQUEST_START'].to_f / 1000
    else
      Time.now.to_f
    end
  end

  def minimum_interval
    @min ||= (@options[:min] || 1.0).to_f
  end

  def notify_via_airbrake(req)
    begin
      Airbrake.notify :error_class => 'API Rate limited exceeded', :error_message => "Rate limit exceeded for #{client_identifier(req)}"
    rescue
      p 'No Airbrake gem installed!'
    end
  end

end