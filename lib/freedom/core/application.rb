module Freedom
  class BaseApplication
    def initialize
      @routing_table = {}
      routes
    end

    def call(env)
      req = Freedom::Request.new(env)
      resolve(req)
    end

    def routes
      raise NotImplementedError.new
    end

    def get(table_data)
      route("GET", table_data)
    end

    def post(table_data)
      route("POST", table_data)
    end

    def put(table_data)
      route("PUT", table_data)
    end

    def delete(table_data)
      route("DELETE", table_data)
    end

    def head(table_data)
      route("HEAD", table_data)
    end

    def options(table_data)
      route("OPTIONS", table_data)
    end

    def patch(table_data)
      route("PATCH", table_data)
    end

    def link(table_data)
      route("LINK", table_data)
    end

    def unlink(table_data)
      route("UNLINK", table_data)
    end

    private

    def route(http_method, table_data)
      table_data.each do |path, controller_action|
        controller_name, action_name = controller_action.split("#")
        controller_class = Kernel.const_get(controller_name)
        @routing_table[[http_method, path]] = [controller_class.new, action_name.to_sym]
      end
    end

    def resolve(request)
      result, match_data = match_routing_table(request)
      if result
        controller, action = *result
        begin
          res = controller.call(action, request)
          res.finish
        rescue => e
          STDERR.puts e.full_message
          status_500
        end
      else
        if File.exist?("#{Dir.pwd}/#{Config.public_dir}#{request.path_info}")
          files = Rack::Files.new(Config.public_dir)
          files.get(request.env)
        else
          status_404
        end
      end
    end

    def match_routing_table(request)
      @routing_table.each do |key, val|
        http_method, path = *key
        next unless http_method == request.request_method
        if path.is_a?(String)
          return [val, nil] if path == request.path_info
        elsif path.is_a?(Regexp)
          match_data = request.path_info.match(path)
          return [val, match_data] if match_data
        end
      end
      [nil, nil]
    end

    def status_404
      res = Response.new(["404 Not Found"], 404)
      res.finish
    end

    def status_500
      res = Response.new(["500 Internal Server Error"], 500)
      res.finish
    end
  end

  class Application < BaseApplication
    def self.start(options = {})
      self.new(options).start
    end

    def initialize(options = {})
      super()
      @options = options.clone
      @middlewares = default_middlewares
      @rack_server = nil
    end

    def built?
      !!@rack_server
    end

    def build
      builder = Rack::Builder.new(self)
      @middlewares.each do |middleware_array|
        builder.use(*middleware_array)
      end
      rack_options = @options
      rack_options[:app] = builder.to_app
      rack_options[:Port] = 5700 unless rack_options[:Port]
      @rack_server = Rack::Server.new(rack_options)
    end

    def start
      build unless built?
      @rack_server.start
    end

    def add_middleware(middleware_class, *middleware_args)
      @middlewares << [middleware_class, *middleware_args]
    end

    private

    def default_middlewares
      [
        [Rack::CommonLogger, ::Logger.new(Config.log_file_name)],
        [Rack::Protection::PathTraversal],
      ]
    end
  end
end
