module Freedom
  class Request < Rack::Request
    def initialize(env)
      super(env)
      @post_data = nil
      @domain = nil
      @scheme = nil
    end

    def post_data
      return @post_data if @post_data
      @post_data = body.read
    end

    def domain
      return @domain if @domain
      match_data = @env["REQUEST_URI"].match(/.+\:\/\/(.+?)\//)
      @domain = match_data[1]
    end

    def scheme
      return @scheme if @scheme
      match_data = @env["REQUEST_URI"].match(/(.+)\:\/\//)
      @scheme = match_data[1]
    end
  end
end
