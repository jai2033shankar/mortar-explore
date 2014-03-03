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

require "explore/mortar/local/controller"
require "mortar/command/base"

# explore the results of mortar recsys
class Mortar::Command::Explore < Mortar::Command::Base


  # explore RECSYS_RESULTS 
  #
  # Watch a local script for changes, and illustrate data flowing through
  # while you work.
  #
  # -t, --port PORT  # What port the pig server should run on.
  #
  # Examples:
  #
  #        $ mortar explore data/out/item-item 
  def index
    results_data  = shift_argument
    unless results_data 
      error("Usage: mortar explore OUTPUT_DIRECTORY\nMust specify DIRECTORY.")
    end
    validate_arguments!
    ctrl = Mortar::Local::Controller.new
    

    ctrl.explore(project, results_data, options[:port])
  end


  # voyage S3_BUCKET
  #
  # Explore through your results stored in an s3 bucket
  #
  # -t, --port PORT  # What port the pig server should run on.
  # -l, --local DOWNLOAD_DIR # Download bucket to local machine for viewing, specify where to download to
  #
  # Examples:
  #
  #     $ mortar voyage s3://mortar-example
  def voyage
    s3_bucket = shift_argument
    unless s3_bucket
      error("Usage: mortar voyage S3_BUCKET\nMust specify bucket.")
    end
    ctrl = Mortar::Local::Controller.new

    ctrl.voyage(project, s3_bucket, options[:port])

  end
  alias_command "voyage", "explore:voyage"
end
