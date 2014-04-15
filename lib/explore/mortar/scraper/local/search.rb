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
require 'explore/mortar/scraper/parse' 

module Local
  class Search
    include Parse
    attr_accessor :base_directory, :delim_char
    def initialize(base_directory, delim_char = "\t")
      @base_directory = base_directory
      @delim_char = delim_char 
    end
    
    def search(query)
      cmd = "grep -rn '" + query + "' " +  @base_directory 
      results = %x[#{cmd}]
      error = nil

      if (results == nil or results == "")
        error = "Search string found nothing.  Please specify again"
        results = []
      else
        results = results.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').split("\n")
      end
      return parse_results(results, error) 
    end
  end
end
