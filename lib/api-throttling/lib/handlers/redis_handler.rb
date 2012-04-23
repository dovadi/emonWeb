module Handlers
  class RedisHandler < Handler
    cache_class "Redis"
    
    def increment(key)
      @cache.incr(key)
    end
    
    def set(key, value)
      @cache[key] = value
    end

    def get(key)
      @cache[key]
    end
    
    Handlers.add_handler self
  end
end