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
$.mortar_data = $.mortar_data || {};
$.mortar_data.api = $.mortar_data.api || {};

$.mortar_data.api.get_browse = function(quantity, index, directory, success_callback, error_callback){
  var params = {
    quantity  : quantity,  
    index     : index,
    directory : directory
  };
  $.ajax({
    url: '/api/v1/browse',
    data:params,
    success: success_callback, 
    error: error_callback 
  });
};


$.mortar_data.api.get_search = function(search_text, success_callback, error_callback){
  var params = {
    query : search_text
  };

  $.ajax({
    url: '/api/v1/search',
    data: params,
    success: success_callback,
    error: error_callback
  });
};

$.mortar_data.api.get_recommend = function(query, directory, success_callback, error_callback){
  var params = {
    query : query,
    directory: directory
  };

  $.ajax({
    url: '/api/v1/recommend',
    data: params,
    success: success_callback,
    error: error_callback
  });
};


$.mortar_data.api.put_url_config = function(params){

  $.ajax({
    url: '/api/v1/config',
    data: params,
    type: 'PUT' 
  });

};
