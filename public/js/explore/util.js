//  Copyright 2014 Mortar Data Inc.
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
// 
//      http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
/*
 * Generic functions for  basic object manipulation
 */

$.mortar_data = $.mortar_data || {};
$.mortar_data.util = $.mortar_data.util = {};

$.mortar_data.util.capitalize_first_letter = function(str){
  return str.charAt(0).toUpperCase() + str.slice(1); 
};

$.mortar_data.util.get_largest_array = function(json_obj){
  var largest_array = []; //only one array will have content, so pick the largest
  var count = 0;
  for(key in json_obj){
    if(json_obj[key] instanceof Array){
      var curr_array = json_obj[key];
      // biggest array
      if(curr_array.length > count){
        count  = curr_array.length;
        largest_array = curr_array;
      }
    }
  }
  return largest_array;
};

