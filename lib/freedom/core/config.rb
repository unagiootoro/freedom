module Freedom
  module Config
    class << self
      attr_accessor :public_dir
      attr_accessor :views_dir
      attr_accessor :controller_dir

      attr_accessor :encoding

      attr_accessor :log_file_name
    end
  end

  Config.public_dir = "public"
  Config.views_dir = "views"
  Config.controller_dir = "controller"

  Config.encoding = "UTF-8"

  Config.log_file_name = "logfile.txt"
end
