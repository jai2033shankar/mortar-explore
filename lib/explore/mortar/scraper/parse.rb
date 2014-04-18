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
require "uri"
module Parse
  II_COUNT = 5
  UI_COUNT = 7

  # returns a specific line in a file
  def get_line_in_file(file, line)
    cmd = "sed -n '#{line}p' #{file}"
    result = %x[#{cmd}]
  end

  def get_lines_in_file(start_line, end_line, file)
    cmd = "sed -n '#{start_line},#{end_line}p' #{file}" 
    result = %x[#{cmd}]
    return result
  end

  def search_column(file, query, column, delim_char)
    extracted = extract_special_characters(query)
    cmd = "awk -F '#{delim_char}' '$1==\"#{extracted}\" {print NR,$0}' #{file}"
    result = %x[#{cmd}]
  end

  def search_directory(query, directory)
    extracted = extract_special_characters(query) 
    cmd = "grep -rn '" + extracted + "' " +  directory 
    results = %x[#{cmd}]
  end

  def extract_special_characters(query)
    extracted = query.gsub("\"", '\\"')
    extracted = extracted.gsub("'", "\047\042\047\042\047")
  end

  def find_file(directory_or_file)
    file = nil
    if File.directory?(directory_or_file)
      all_contents = Dir.entries(directory_or_file)
      contents = Array.new
      for item in all_contents do
        relative_path = "#{directory_or_file}/#{item}"

        if is_file(relative_path)
          if ! is_hidden_file(item)
            contents.push(item)
          end
        end
      end

      if(contents[0]!=nil)
        file = "#{directory_or_file}/#{contents[0]}"
      end
    elsif File.exists?(directory_or_file)
      file = directory_or_file 
    end
    return file
  end

  def is_hidden_file(item)
    item[0,1] == "." || item[0,1] == "_"
  end

  def is_file(relative_path)
    File.exists?(relative_path) && ! File.directory?(relative_path)
  end
    

  # parse results from a string array 
  #     input_array - array of strings where strings are formated as...
  #           FILE_PATH:LINE_NUMBER:Line_DATA
  #           *NOTE the ':' character is used to seperate the fields
  #           this fails if a directory name has ':' in it
  def parse_results(input_array, error= nil, mode="local")
    results = {
      :generic_item => Array.new,
      :error => error 
    }
    input_array.each do |row|
      begin
        search_data = row.split(':', 3)
        row_data = search_data[2].split(delim_char).map(&:strip)
        parse_generic_item(row_data, search_data, results[:generic_item])
      rescue
      end
    end 
    return results 
  end
  
  def parse_generic_item(row_data, search_data, arr)
    hash = {} 
    hash["line"] = search_data[1]
    i = 1
    for item in row_data
      col_name = "column#{i.to_s}"
      hash[col_name] = item
      i += 1
    end
    hash["file"] = search_data[0] 
    arr.push(hash)
  end

end
  
