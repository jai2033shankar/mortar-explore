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
    f = File.open(file)
    [*f][line-1]
  end

  # parse results from a search query
  def parse_results(input_array)
     results = {
      :item_item_recs => Array.new,
      :user_item_recs => Array.new
    }
    for row in input_array do
      search_data = row.split(':', 3)
      row_data = search_data[2].split(delim_char).map(&:strip)
      if row_data.length == II_COUNT  
        parse_item_item(row_data, search_data, results[:item_item_recs])
      elsif row_data.length == UI_COUNT
        parse_user_item(row_data, search_data, results[:user_item_recs])
      end
    end 
    return results 
  end


  def parse_item_item(row_data, search_data, arr)
    arr.push({
      :item_A => row_data[0], 
      :item_B => row_data[1], 
      :weight => row_data[2], 
      :raw_weight => row_data[3], 
      :rank => row_data[4], 
      :line => search_data[1],
      :file => search_data[0],
      :type => "item_item"
    }) 
  end

  def parse_user_item(row_data, search_data, arr)
    arr.push({
      :user => row_data[0],
      :item => row_data[1],
      :weight => row_data[2],
      :reason_item => row_data[3],  
      :user_reason_item_weight => row_data[4],  
      :item_reason_item_weight => row_data[5],  
      :rank => row_data[6],  
      :line => search_data[1],
      :file => search_data[0],
      :type => "user_item"
    })
  end

  

end
  
