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

class Server < Sinatra::Base
  # Load the basic page 
  get '/' do
    @search_template = File.read(settings.resource_locations["search"]).to_s
    @browse_template = File.read(settings.resource_locations["browse"]).to_s
    erb File.read(settings.resource_locations["index"]).to_s
  end

  # Api call to search for string
  # Requires 'query' param
  # api/vq1/search?query='SEARCH_STRING'
  get'/api/v1/search' do
    query = params[:query] 
    searcher = settings.searcher 
    print '\nsearching...'
    print params
    if searcher == nil
      body {{:error => 'Cannot search in this mode.'}.to_json}
    elsif query != nil and query != "" 
      body{ searcher.search(query).to_json}
    else
      print 'return no search error'
      body {{:error => 'No search query was given.  Please specify'}.to_json}
    end
  end

  get '/api/v1/browse' do
    print '\nbrowsing...'
    browser = settings.browser 
    print params
    params[:quantity] == nil ? quantity = 10 : quantity = params[:quantity].to_i 
    params[:index] == nil ? index = browser.index : index = params[:index].to_i
    params[:directory] == nil or params[:directory] == "" ? directory = "" : directory = params[:directory] 
    body { browser.browse(quantity, index, directory).to_json }
  end 


end



# Globally set certain server attributes
public_folder_str = "../../../../../public"
Server.set :public_folder, File.expand_path( public_folder_str,__FILE__)
Server.set(:resource_locations, {
  "index" => File.expand_path(public_folder_str + "/index.html", __FILE__),
  "search" => File.expand_path(public_folder_str + "/templates/search.html", __FILE__),
  "browse" => File.expand_path(public_folder_str + "/templates/browse.html", __FILE__)
})
