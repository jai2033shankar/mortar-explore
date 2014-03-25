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
