require "redcarpet"

module Freedom
  class Controller
    def markdown(md, extension = {})
      return_html(markdown_to_html(md, extension))
    end

    def markdown_to_html(md, extension = {})
      mkdown_obj = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extension)
      mkdown_obj.render(md)
    end
  end
end
