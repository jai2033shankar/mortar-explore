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
require 'sinatra/async'
require 'thin'

module Sinatra
  module Pollers
    POLLER_TYPES = [:file_watchers, :illustrate_watchers]

    def self.registered(app)
      POLLER_TYPES.each do |poller|
        app.set poller, []
      end
    end

    # Public: Notify a given poller that something has happened
    #
    # poller_type - one of the POLLER_TYPES symbol
    # *args - the arguments to be passed to the poller
    # 
    # Returns nothing.
    def notify(poller_type, *args)
      self.settings.send(poller_type).each do |poller|
        poller.call(*args)
      end
      self.set poller_type, []
    end
  end

  register Pollers
end
class Server < Sinatra::Base
#  register Sinatra::Async
  #register Sinatra::Pollers

  # Load the basic page 
  get '/' do
    @query_template = File.read(settings.resource_locations["paint"]).to_s
    erb File.read(settings.resource_locations["index"]).to_s
  end


end
# Globally set certain server attributes
public_folder_str = "../../../../../public"
Server.set :public_folder, File.expand_path( public_folder_str,__FILE__)
Server.set(:resource_locations, {
  "index" => File.expand_path(public_folder_str + "/templates/index.html", __FILE__),
  "paint" => File.expand_path(public_folder_str + "/templates/underscore/query.html", __FILE__)
})

