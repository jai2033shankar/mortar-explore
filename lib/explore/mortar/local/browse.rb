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
  def browse(quantity, start_index = @index, directory_or_file = nil)
    raw_browsed, error = browse_from_directory(quantity, start_index, directory_or_file) 
    @index = start_index + raw_browsed.length #next time, it will start at the next index
    return parse_results(raw_browsed, error)
  end


  def browse_from_directory(quantity, start_index, directory_or_file)
    directory_or_file == nil ? directory_or_file = @base_directory:  directory_or_file = @base_directory + "/" + directory_or_file
    file = find_file (directory_or_file)
    if file != nil 
      raw_browsed = Array.new
      cmd = "sed -n '#{start_index},#{start_index+quantity-1}p' #{file}" 
      result = %x[#{cmd}]
      i = start_index 
      for row in result.split("\n") do
        raw_browsed.push( file + ":" + i.to_s + ":" + row ) 
        i = i + 1 
      end
      return raw_browsed, nil
    else
      return Array.new, "The requested directory or file, #{directory_or_file}, does not exist.  Please specify again." 
    end
  end

  def find_file(directory_or_file)
    file = nil
    if File.directory?(directory_or_file)
      all_contents = Dir.entries(directory_or_file)
      contents = Array.new
      for item in all_contents do
        if File.exists?(directory_or_file +"/" +  item)
          # TODO -- sort and use real file names
          if (item == "part-r-00000")
            contents.push(item)
          end
        end
      end
      file = directory_or_file + "/" + contents[0]
      
    elsif File.exists?(directory_or_file)
      file = directory_or_file 
    end
    return file
  end
  

end
