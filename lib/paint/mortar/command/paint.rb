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

require "paint/mortar/local/controller"
require "mortar/command/base"

# Paint results of mortar recsys
class Mortar::Command::Paint < Mortar::Command::Base


  # paint RECSYS_RESULTS 
  #
  # Watch a local script for changes, and illustrate data flowing through
  # while you work.
  #
  # -t, --port PORT  # What port the pig server should run on.
  #
  # Examples:
  #
  #        $ mortar paint data/out/item-item 
  def index
    results_data  = shift_argument
    unless results_data 
      error("Usage: mortar local:watch PIGSCRIPT\nMust specify PIGSCRIPT.")
    end
    validate_arguments!
    ctrl = Mortar::Local::Controller.new
    

    ctrl.paint(project, results_data, options[:port])
  end
end
