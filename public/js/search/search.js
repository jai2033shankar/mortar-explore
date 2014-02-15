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
$.mortar_data.search_view = $.mortar_data.search_view || {};


(function(){
  var search_tables =[];
  $.mortar_data.search_view.init = function(){
    init_search();  
  }

  function init_search(){
    $('#search_button').on('click', fire_search);  
  };

  function load_search(data){
    console.log(data);
    var data_parsed = JSON.parse(data);

    $('#search_results').empty();
    search_tables = [];
    if(data_parsed.error == null){
      $('#search_error_row').addClass('hidden');
      for (key in data_parsed){
        var item = data_parsed[key];
        if(item instanceof Array){
          if(item.length>0){
            var container_id = 'search_' + key+'_table';
            $('#search_results').append('<div id="'+container_id+'"></div>');
            search_tables.push( new MortarTable(
                    '#' + container_id,
                    item,
                    {
                      page_limit : 50,
                      detail_button: MODE == 'recsys'? 1: null
                    }
                  ));
          }
        }
        
      } 
      for(var i = 0; i < search_tables.length; i++){
        search_tables[i].draw(); 
      }
    }else{
      fire_search_error(data_parsed.error); 
    }
  };
  
  function fire_search_error(error_message){
    $('#search_error_row').removeClass('hidden');
    $('#search_error').text(error_message);

  }; 
  
  function search_error(data){
     
  };

  function show_progress(){
     
  };

  function fire_search(){
    var search_field = $('#search_query').val().trim();
    $('#search_text').text('Search results for "' + search_field + '"');
    if (search_field != ''){
      $.mortar_data.api.get_search(search_field, load_search, search_error);
    }else{
      $('#search_results').empty();
      fire_search_error('No search query was given.  Please specify'); 
    }
  }

})();
