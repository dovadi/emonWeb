module HeaderFilter

  class P1

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      req = Rack::Request.new(env)
      unused_headers.each {|key| headers.delete(key)} if p1_request?(req)

      [status, headers, body]
    end

    private

    def p1_request?(req)
      "#{req.request_method} #{req.path}".match('POST /p1')
    end

    def unused_headers
      ['Set-Cookie', 'X-UA-Compatible', 'ETag', 'Content-Type', 'Cache-Control']
    end
  end

end