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
  class Recommend
    include Parse
    attr_accessor :base_directory, :delim_char

    def initialize(base_directory, delim_char = "\t")
      @base_directory = base_directory
      @delim_char = delim_char 
    end

    def get_recommendations(item_id, directory_or_file)
      raw_recommendations = get_recommendations_from_directory(item_id, directory_or_file)
      error = nil
      results = parse_results(raw_recommendations, error)
      results[:location] = directory_or_file
      return results
    end

    def get_recommendations_from_directory(item_id, directory_or_file)
      directory_or_file = directory_or_file == nil ?  @base_directory : @base_directory + "/" + directory_or_file
      file = find_file (directory_or_file)
      raw_str = search_column(file, item_id, "1") 
      raw_recs = Array.new
      for row in raw_str.split("\n")
        line, contents = row.split(" ", 2)

        raw_recs.push("#{file}:#{line}:#{contents}")
      end
      print raw_recs
      return raw_recs
    end

  end
end
