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
  end

  def search_column(file, query, column, delim_char)
    cmd = "awk -F '#{delim_char}' '$1==\"#{query}\" {print NR,$0}' #{file}"
    result = %x[#{cmd}]
  end

  def find_file(directory_or_file)
    file = nil
    if File.directory?(directory_or_file)
      all_contents = Dir.entries(directory_or_file)
      contents = Array.new
      for item in all_contents do
        if File.exists?(directory_or_file +"/" +  item)
          # TODO -- sort and use real file names
          if (item[0,1] != "." and item[0,1] != "_")
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
    

  # parse results from a string array 
  #     input_array - array of strings where strings are formated as...
  #           FILE_PATH:LINE_NUMBER:Line_DATA
  #           *NOTE the ':' character is used to seperate the fields
  #           this fails if a directory name has ':' in it
  def parse_results(input_array, error= nil, mode="local")
    results = {
      #:item_item_recs => Array.new,
      :generic_item => Array.new,
      #:user_item_recs => Array.new,
      :error => error 
    }
    input_array.each do |row|
      begin
        search_data = row.split(':', 3)
        row_data = search_data[2].split(delim_char).map(&:strip)
        parse_generic_item(row_data, search_data, results[:generic_item])
      #  if row_data.length == II_COUNT  
      #    parse_item_item(row_data, search_data, results[:item_item_recs])
      #  elsif row_data.length == UI_COUNT
      #    parse_user_item(row_data, search_data, results[:user_item_recs])
      #  else
      #    parse_generic_item(search_data[2], search_data, results[:generic_item])
      #  end
      rescue
      end
    end 
    return results 
  end
  
  # Parses the row data and search data by pushing it to the item-item array
  #     row_data - see macro output for detailed schema, follows the schema
  #     search_data - metadata and each row including [ FILE_NAME, LINE_NUMBER]
  #     arr - resulting array hash map is pushed to
  def parse_item_item(row_data, search_data, arr)
    
    arr.push({
      :line => search_data[1],
      :item_A => row_data[0], 
      :item_B => row_data[1], 
      :weight => row_data[2], 
      :raw_weight => row_data[3], 
      :rank => row_data[4],
      :type => "item_item",
      :file => search_data[0],
    }) 
  end

  # Parses the row data and search data by pushing it to the user-item array
  #     row_data - see macro output for detailed schema, follows the schema
  #     search_data - metadata and each row including [ FILE_NAME, LINE_NUMBER]
  #     arr - resulting array hash map is pushed to
  def parse_user_item(row_data, search_data, arr)
    arr.push({
      :line => search_data[1],
      :user => row_data[0],
      :item => row_data[1],
      :weight => row_data[2],
      :reason_item => row_data[3],  
      :user_reason_item_weight => row_data[4],  
      :item_reason_item_weight => row_data[5],  
      :rank => row_data[6],
      :type => "user_item",
      :file => search_data[0]
    })
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
  
