/*
 * Generic functions for  basic object manipulation
 */

$.mortar_data = $.mortar_data || {};
$.mortar_data.util = $.mortar_data.util = {};

$.mortar_data.util.capitalize_first_letter = function(str){
  return str.charAt(0).toUpperCase() + str.slice(1); 
};
