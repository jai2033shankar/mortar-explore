require "mortar/helpers"
require "explore/mortar/local/server"
require "mortar/local/installutil"

require 'sinatra/base'
require 'thin'
require "json"
require "listen"
require "logger"

# This class manages the web server and other files to see how they will react
#


class Mortar::Local::Explorer
    include Mortar::Local::InstallUtil

    EXPLORER_LOG_FILE = "explore-explorer.log"

    # Public: Initialize the watcher utility
    #
    # project_root_path
    #
    # Returns an Explorer object
    def initialize(project_root_path)
        @project_root_path = project_root_path

        @log ||= Logger.new("#{local_log_dir}/#{EXPLORER_LOG_FILE}")
        @log.level = Logger::DEBUG
    end
	
end
