#
# Copyright 2014 Mortar Data Inc.
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
    @detail_template = File.read(settings.resource_locations["detail"]).to_s
    if settings.mode == "recsys"
      @image_url = settings.image_url.to_s
      @item_url = settings.item_url.to_s
    end
    erb File.read(settings.resource_locations["index"]).to_s
  end

  # Api call to search for string
  # Requires 'query' param
  # api/vq1/search?query='SEARCH_STRING'
  get'/api/v1/search' do
    query = params[:query] 
    searcher = settings.searcher 
    print '\nsearching...'
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
    params[:quantity] == nil ? quantity = 10 : quantity = params[:quantity].to_i 
    params[:index] == nil ? index = browser.index : index = params[:index].to_i
    params[:directory] == nil or params[:directory] == "" ? directory = "" : directory = params[:directory] 
    body { browser.browse(quantity, index, directory).to_json }
  end 

  get '/api/v1/recommend' do
    item_a = params[:query]
    directory = (params[:directory] == nil or params[:directory] == "") ?  nil : params[:directory] 
    recommender  = settings.recommender
    if recommender == nil
      body {{:error => 'Can not recommend in this mode.'}.to_json}
    elsif item_a == nil
      body {{:error => 'No query was given.'}.to_json}
    else
      body { recommender.get_recommendations(item_a, directory).to_json}
    end
  end


  put '/api/v1/config' do
    image_url = (params[:image_url] == nil or params[:image_url] == "") ?  settings.image_url : params[:image_url]
    item_url = (params[:item_url] == nil or params[:item_url] == "") ?  settings.item_url : params[:item_url]
    item_key = (params[:item_key] == nil or params[:item_key] == "") ?  settings.item_key : params[:item_key]
    recommendation_key = (params[:recommendation_key] == nil or params[:recommendation_key] == "") ?  settings.recommendation_key : params[:recommendation_key]
    rank_key = (params[:rank_key] == nil or params[:rank_key] == "") ?  settings.rank_key : params[:rank_key]
    settings.image_url = image_url
    settings.item_url = item_url 
    settings.item_key = item_key
    settings.recommendation_key = recommendation_key 
    settings.rank_key = rank_key 

    display 'saving configurations...'

    settings.explorer.set_config image_url, item_url, item_key, recommendation_key, rank_key
  end


end



# Globally set certain server attributes
public_folder_str = "../../../../../public"
Server.set :public_folder, File.expand_path( public_folder_str,__FILE__)
Server.set(:resource_locations, {
  "index" => File.expand_path(public_folder_str + "/index.html", __FILE__),
  "search" => File.expand_path(public_folder_str + "/templates/search.html", __FILE__),
  "detail" => File.expand_path(public_folder_str + "/templates/details.html", __FILE__),
  "browse" => File.expand_path(public_folder_str + "/templates/browse.html", __FILE__)
})
