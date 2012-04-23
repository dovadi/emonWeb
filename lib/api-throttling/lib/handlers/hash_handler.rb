module Handlers
  class HashHandler < Handler
    cache_class "Hash"
    
    def increment(key)
      @cache[key] = (get(key)||0).to_i+1
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