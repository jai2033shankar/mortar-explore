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
require 'explore/mortar/local/parse' 

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
  def browse(quantity, start_index = @index, directory = nil)
    part_file_number = "00000" 
    directory == nil ? directory = @base_directory:  directory = @base_directory + "/" + directory
    file = directory + "/part-r-" + part_file_number
    raw_browsed = Array.new
    for i in start_index .. start_index + quantity
      # check if end of file...
      
      # string is modified to match parse_results function
      raw_browsed.push( directory + ":" +i.to_s + ":" + get_line_in_file(file, i) )
    end
    @index = start_index + quantity + 1 #next time, it will start at the next index
    print @index
    return parse_results(raw_browsed)
  end

end
