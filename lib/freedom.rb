require "rack"
require "rack-protection"
require "uri"
require "erb"
require "logger"

module Freedom; end

require_relative "freedom/version"
require_relative "freedom/core/application"
require_relative "freedom/core/controller"
require_relative "freedom/core/request"
require_relative "freedom/core/response"
require_relative "freedom/core/config"
