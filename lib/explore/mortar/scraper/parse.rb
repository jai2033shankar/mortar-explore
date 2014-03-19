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

  # parse results from a string array 
  #     input_array - array of strings where strings are formated as...
  #           FILE_PATH:LINE_NUMBER:Line_DATA
  #           *NOTE the ':' character is used to seperate the fields
  #           this fails if a directory name has ':' in it
  def parse_results(input_array, error= nil)
    results = {
      :item_item_recs => Array.new,
      :user_item_recs => Array.new,
      :error => error 
    }
    input_array.each do |row|
      begin
        search_data = row.split(':', 3)
        row_data = search_data[2].split(delim_char).map(&:strip)
        if row_data.length == II_COUNT  
          parse_item_item(row_data, search_data, results[:item_item_recs])
        elsif row_data.length == UI_COUNT
          parse_user_item(row_data, search_data, results[:user_item_recs])
        end
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
      :file => search_data[0],
      :type => "item_item",
      :item_A => row_data[0], 
      :item_B => row_data[1], 
      :weight => row_data[2], 
      :raw_weight => row_data[3], 
      :rank => row_data[4]
    }) 
  end

  # Parses the row data and search data by pushing it to the user-item array
  #     row_data - see macro output for detailed schema, follows the schema
  #     search_data - metadata and each row including [ FILE_NAME, LINE_NUMBER]
  #     arr - resulting array hash map is pushed to
  def parse_user_item(row_data, search_data, arr)
    arr.push({
      :line => search_data[1],
      :file => search_data[0],
      :type => "user_item",
      :user => row_data[0],
      :item => row_data[1],
      :weight => row_data[2],
      :reason_item => row_data[3],  
      :user_reason_item_weight => row_data[4],  
      :item_reason_item_weight => row_data[5],  
      :rank => row_data[6]  
    })
  end
  

end
  
