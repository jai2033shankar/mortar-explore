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
require 'thin'

class Server < Sinatra::Base
#  register Sinatra::Async
  #register Sinatra::Pollers

  # Load the basic page 
  get '/' do
    @query_template = File.read(settings.resource_locations["query"]).to_s
    erb File.read(settings.resource_locations["index"]).to_s
  end


end



# Globally set certain server attributes
public_folder_str = "../../../../../public"
Server.set :public_folder, File.expand_path( public_folder_str,__FILE__)
Server.set(:resource_locations, {
  "index" => File.expand_path(public_folder_str + "/index.html", __FILE__),
  "query" => File.expand_path(public_folder_str + "/templates/query.html", __FILE__)
})

