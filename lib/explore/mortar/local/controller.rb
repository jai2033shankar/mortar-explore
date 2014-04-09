#
# Copyright 2013 Mortar Data Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require "explore/mortar/local/explorer"
require 'explore/mortar/scraper/local/search'
require 'explore/mortar/scraper/local/browse'
require 'explore/mortar/scraper/local/recommend'
require 'explore/mortar/scraper/cloud/browse'
require "mortar/local/controller"

class Mortar::Local::Controller
  def explore(project, data_directory, port, recsys=nil)
    port ||= 3000 
    explorer = Mortar::Local::Explorer.new(project.root_path)

    # Startup Web server
    Server.set :mode, recsys ? "recsys" : "local"
    Server.set :data_directory, data_directory 
    Server.set :project_root, project.root_path
    Server.set :searcher, Local::Search.new(data_directory)
    Server.set :browser, Local::Browse.new(data_directory)
    Server.set :recommender, recsys ? Local::Recommend.new(data_directory) : nil
    Server.set :explorer, explorer
    if recsys
      image_url, item_url, item_key, recommendation_key, rank_key  =  explorer.get_config
      Server.set :image_url, image_url
      Server.set :item_url, item_url
      Server.set :item_key, item_key 
      Server.set :recommendation_key, recommendation_key 
      Server.set :rank_key, rank_key 
    end
    begin
      server = Thin::Server.new(Server, '0.0.0.0', port, :signals => false)
    rescue => e
      print 'error'
    end

    launch_browser(port)
    server.start

  end

  def voyage(project, s3_path, directory = nil, port = 3000)
    require_aws_keys
    
    explorer = Mortar::Local::Explorer.new(project.root_path)

    Server.set :mode, "cloud" 
    Server.set :data_directory, s3_path 
    Server.set :project_root, project.root_path
    Server.set :searcher, nil 
    Server.set :browser, Cloud::Browse.new(s3_path)

    begin
      server = Thin::Server.new(Server, '0.0.0.0', port, :signals => false)
    rescue => e
      print 'error'
    end

    launch_browser(port)
    server.start


    # Startup Web Server
  end


  def download_from_bucket(s3_path, output_directory)
        
  end

  private

  # Private: launch the web browser once we've heard back and
  # verified the pigjig server has started
  #
  # Returns nothing
  def launch_browser(port) 
    print 'opening browser...'
    begin
      require "launchy"
      Launchy.open("http://localhost:#{port}")
    rescue => msg
      warning "Unable to automatically launch browser. Please visit http://localhost:#{port}"
    end
  end


end
