require "mortar/helpers"
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
    CONFIG_FILE = File.expand_path "~/.mortar-explore-config"

    # project_root_path
    #
    # Returns an Explorer object
    def initialize(project_root_path)
        @project_root_path = project_root_path

        @log ||= Logger.new("#{local_log_dir}/#{EXPLORER_LOG_FILE}")
        @log.level = Logger::DEBUG
    end

    def get_config
      if File.exists? CONFIG_FILE
        image_url, item_url, item_key, recommendation_key, rank_key = File.open(CONFIG_FILE, 'r').read().split("\n").collect { |x| x.split('~>')[1].strip}
        print [image_url, item_url, item_key, recommendation_key, rank_key]
        return image_url, item_url, item_key, recommendation_key, rank_key
      end
    end

    def set_config(image_url, item_url, item_key, recommendation_key, rank_key)
      f = File.open(CONFIG_FILE, 'w')
      f.puts("image_url ~> #{image_url}")
      f.puts("item_url ~> #{item_url}")
      f.puts("item_key ~> #{item_key}")
      f.puts("recommendation_key ~> #{recommendation_key}")
      f.puts("rank_key ~> #{rank_key}")
      f.close()
    end

    def ask(prompt)
       print prompt
       $stdin.gets.to_s.strip
    end
	
end
