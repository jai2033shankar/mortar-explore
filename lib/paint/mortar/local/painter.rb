require "mortar/helpers"
require "paint/mortar/local/server"

require 'sinatra/base'
require 'thin'
require "json"
require "listen"
require "logger"

# This class manages the web server and other files to see how they will react
#


class Mortar::Local::Painter
    include Mortar::Local::InstallUtil

    PAINTER_LOG_FILE = "paint-painter.log"

    # Public: Initialize the watcher utility
    #
    # project_root_path
    #
    # Returns a Watcher object
    def initialize(project_root_path)
        @project_root_path = project_root_path

        @log ||= Logger.new("#{local_log_dir}/#{PAINTER_LOG_FILE}")
        @log.level = Logger::DEBUG
    end
	
end
