module Freedom
  class Controller
    def initialize
      @request = nil
      @response = nil
    end

    def call(action, req)
      @request = req
      @response = Response.new(nil, 200)
      catch(:halt) do
        body = send(action)
        return_plain
      end
      @response
    end

    def request
      @request
    end

    def response
      @response
    end

    def params
      @request.params
    end

    def return_plain(body)
      @response.content_type = "text/plain;charset=#{Config.encoding}"
      halt(body: body)
    end

    def return_html(body)
      @response.content_type = "text/html;charset=#{Config.encoding}"
      halt(body: body)
    end

    def return_json(body)
      @response.content_type = "application/json"
      halt(body: body)
    end

    def html(name)
      html = File.read("#{Config.views_dir}/#{name}.html")
      return_html(html)
    end

    def erb(name)
      html = ERB.new(File.read("#{Config.views_dir}/#{name}.erb", encoding: Config.encoding)).result(binding)
      return_html(html)
    end

    def get_cookie(key)
      @request.cookies[key]
    end

    def set_cookie(key, cookie)
      hash = cookie.is_a?(String) ? { value: cookie} : cookie
      @response.set_cookie(key, hash)
    end

    def url(path, scheme = nil)
      scheme ||= @request.scheme
      "#{scheme}://#{@request.domain + path}"
    end

    def redirect(uri)
      @response.location = uri
      halt status: 303
    end

    def halt(body: nil, status: 200)
      @response.status = status if status
      @response.body = [body] if body
      throw :halt
    end
  end
end
