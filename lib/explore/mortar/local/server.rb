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

require 'sinatra/base'
require 'explore/mortar/local/search'

class Server < Sinatra::Base
  # Load the basic page 
  get '/' do
    @query_template = File.read(settings.resource_locations["query"]).to_s
    @browse_template = File.read(settings.resource_locations["browse"]).to_s
    erb File.read(settings.resource_locations["index"]).to_s
  end

  # Api call to search for string
  # Requires 'query' param
  # api/vq1/search?query='SEARCH_STRING'
  get'/api/v1/search' do
    query = params[:query] 
    searcher = settings.searcher 
    if query != nil 
      body{ searcher.search(query) }
    else
      body {}
    end
  end

  get '/api/v1/browse' do
    browser = settings.browser 
    print params
    params[:quantity] == nil ? quantity = 10 : quantity = params[:quantity].to_i 
    params[:index] == nil ? index = browser.index : index = params[:index].to_i
    params[:directory] == nil or params[:directory] == "" ? directory = "item_item_recs" : directory = params[:directory] 
    body { browser.browse(quantity, index, directory).to_json }
  end 


end



# Globally set certain server attributes
public_folder_str = "../../../../../public"
Server.set :public_folder, File.expand_path( public_folder_str,__FILE__)
Server.set(:resource_locations, {
  "index" => File.expand_path(public_folder_str + "/index.html", __FILE__),
  "query" => File.expand_path(public_folder_str + "/templates/query.html", __FILE__),
  "browse" => File.expand_path(public_folder_str + "/templates/browse.html", __FILE__)
})
