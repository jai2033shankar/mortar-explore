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

  def parse_results(input_array)
    arr = Array.new
    for row in input_array do
      print row
      row_data = row.split(delim_char).map(&:strip)
      arr.push({
        :fieldA => row_data[0], 
        :fieldB => row_data[1], 
        :weight => row_data[2], 
        :raw_weight => row_data[3], 
        :rank => row_data[4] 
      }) 
    end 
    return arr
  end
  

end
  
