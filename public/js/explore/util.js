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

