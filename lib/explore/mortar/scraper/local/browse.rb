#
# Copyright 2014 Mortar Data Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
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
  class Browse
    include Parse

    attr_accessor :base_directory, :delim_char, :index

    def initialize(base_directory, delim_char = "\t")
      @base_directory = base_directory
      @delim_char = delim_char 
      @index = 1
    end


    
    # gets a quantity amount of  certain lines from an index   
    #    quantity - how many lines of data will be returned
    #    start_index - what line of the file browse should start from
    #    directory - where the part file is located
    def browse(quantity, start_index = @index, directory_or_file = nil)
      raw_browsed, error = browse_from_directory(quantity, start_index, directory_or_file) 
      @index = start_index + raw_browsed.length #next time, it will start at the next index
      results = parse_results(raw_browsed, error)
      results[:location] = directory_or_file
      return results 
    end


    def browse_from_directory(quantity, start_index, directory_or_file)
      directory_or_file = directory_or_file == nil ?  @base_directory : @base_directory + "/" + directory_or_file
      file = find_file(directory_or_file)
      if file != nil 
        raw_browsed = Array.new
        result = get_lines_in_file(start_index, start_index + quantity-1, file)
        i = start_index 
        for row in result.split("\n") do
          raw_browsed.push( file + ":" + i.to_s + ":" + row ) 
          i = i + 1 
        end
        error = nil
        if raw_browsed.length == 0
          error = "The requested directory or file, #{directory_or_file}, does not exist.  Please specify again."
        end
        return raw_browsed, error 
      else
        return Array.new, "The requested directory or file, #{directory_or_file}, does not exist.  Please specify again." 
      end
    end

  end

end
