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


  def parse_results(input_array)
       results = {
      :item_item_recs => Array.new,
      :user_item_recs => Array.new
    }
    for row in input_array do
      row_no_line_number = row.split(':', 3)
      row_data = row_no_line_number[2].split(delim_char).map(&:strip)
      if row_data.length == II_COUNT  
        results[:item_item_recs].push({
          :item_A => row_data[0], 
          :item_B => row_data[1], 
          :weight => row_data[2], 
          :raw_weight => row_data[3], 
          :rank => row_data[4], 
          :line => row_no_line_number[1],
          :file => row_no_line_number[0],
          :type => "item_item"
        }) 
      elsif row_data.length == UI_COUNT
        results[:user_item_recs].push({
          :user => row_data[0],
          :item => row_data[1],
          :weight => row_data[2],
          :reason_item => row_data[3],  
          :user_reason_item_weight => row_data[4],  
          :item_reason_item_weight => row_data[5],  
          :rank => row_data[6],  
          :line => row_no_line_number[1],
          :file => row_no_line_number[0],
          :type => "user_item"
        })
      end
    end 
    return results 
  end
  

end
  
