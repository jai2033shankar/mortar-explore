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
$.mortar_data = $.mortar_data || {};
$.mortar_data.browse_view = $.mortar_data.browse_view || {};


(function(){

  $.mortar_data.browse_view.init = function(){
    init_browse();  
  }

  var current_index = 1;
  var browse_table;
  /*  Controller Functions */
  function init_browse(){
    browse_table = new MortarTable('#browse_table',[], {
      page_limit: get_browse_by(),
      next_callback : fire_next_page,
      previous_callback : fire_previous_page,
      detail_button: MODE == 'recsys'? 1: null
    });
    $('#browse_update').click(fire_browse_update);  
    get_browse();
  }

  /**
   * Makes api call to /api/v1/browse
   */
  function get_browse(){
    $.mortar_data.api.get_browse(
      get_browse_by(), //quantity 
      current_index, //index to start browse
      get_browse_from(), //directory to browse by 
      fire_reload_table,
      function(){
        console.log('error');
      }
    ); 
  }


  /**
   * data - expect to be an object where each key leads to an array
   */
  function fire_reload_table(data){
    
    var data_parsed = JSON.parse(data);
    if (data_parsed.location == ""){
      data_parsed.location = './'; 
    }
    $('#browse_location').text(data_parsed.location);
    // server returned no error
    if(data_parsed.error == null){
      $('#browse_error_row').addClass('hidden');
      var largest_array = $.mortar_data.util.get_largest_array(data_parsed); //only one array will have content, so pick the largest
      //current_index += largest_array.length; //update current index
      if(largest_array.length > 0){
        current_index = ( Math.floor(current_index/get_browse_by() ) + 1 ) * 50 + 1;
        browse_table.set_array(largest_array);
        browse_table.draw();
      } else{
//fire_browse_error('No file could be found in this directory.  Please specify.'); 
      } 
     
    } else{
      fire_browse_error(data_parsed.error);
    }
    //Checks indexed number for browse
    if(current_index > (get_browse_by() + 1))
      $('.browse_previous_page').removeAttr('disabled');
    else
      $('.browse_previous_page').attr('disabled', 'disabled');
  };


  /*
   * Event when next content is clicked
   */
  function fire_next_page(){
    get_browse();
  };
  
  /*
   * Event when back content is clicked
   */
  function fire_previous_page(){
    current_index = (Math.floor(current_index/get_browse_by())-2)*50 +1;
    current_index = current_index <=0 ? 1 : current_index;
    get_browse(); 
      
  };

  function fire_browse_update(){
    current_index = 1;
    get_browse();
  };

  /*
   * Getter for quantity
   */
  function get_browse_by(){
    return 50; 
  };

  function fire_browse_error(error_message){
    $('#browse_error_row').removeClass('hidden');
    browse_table.erase(); 
    $('#browse_error').text(error_message);
    
  };

  /*
   * Directory or File browse from
   */
  function get_browse_from(){
    return $('#browse_from').val(); 
  };


})();

$.mortar_data = $.mortar_data || {};
$.mortar_data.details_view = $.mortar_data.details_view || {};


(function () {
  $.mortar_data.details_view.init = function(){
    $('i').tooltip();
    init_details();
  }; 
  
  var recommendation_data = [];
  function init_details(){
    get_recommend(); 
    set_img_url(IMAGE_URL);
    set_item_url(ITEM_URL);
    set_breadcrumbs();
    $('#update_url').click(fire_update_url);
    //set_img_src('#item_img', generate_item_img_src());
    $('select').change(function(){
      fire_select_change(recommendation_data); 
    });
  };

    /*
   * Api call to get recommendations for specific query
   */
  function get_recommend(){
    $.mortar_data.api.get_recommend(       
      get_query(),
      '',
      fire_show_details,
      fire_detail_error
    );
  };
  
  function set_breadcrumbs(){
    $('#detail_base').empty();
    var base = get_base_hash();
    base = base.substr(1, base.length);
    $('#detail_base').append('<a href="' + get_base_hash() + '">' + $.mortar_data.util.capitalize_first_letter(base) + '</a>'); 
    $('#detail_id').text(get_query());
  };

  function set_item_src(){
    var query = recommendation_data.length ? recommendation_data[0][get_item_select()] : get_query();
    var item_url = get_item_url().replace('#{id}', query);
    $('#item_link').attr('href', item_url);
    $('#item_link_text').text(item_url);
    return item_url;
  };  

  function set_img_src(item_id, item_img_src){
    var item_id = '#item_img';
    var item_img_src = generate_item_img_src();
    var query = recommendation_data.length ? recommendation_data[0][get_item_select()] : get_query();
    IMAGE_URL = get_img_url();
    ITEM_URL = get_item_url();
    $(item_id).attr('src', item_img_src); 
    $('#item_id_text').text(query);
    $('#recommendation_list img').each(function(index, item){
      var item_id = $(item).attr('data');
      $(item).attr('src', generate_img_url(item_id).replace(' ', '-')); 
    
    });
    $('#image_link_text').text(item_img_src);
    return item_img_src;
  };


  /*
   * sets image url text box
   */
  function set_img_url(url){
    $('#image_url').val(url);
  };

  function set_item_url(url){
    $('#itegm_url').val(url);
  };

  function set_item_select(val){
    $('#item_select').val(val); 
  };

  function set_recommendation_select(val){
    $('#recommendation_select').val(val); 
  };
  
  function set_rank_select(val){
    $('#rank_select').val(val);
  };


  /*
   * getters
   */
  function get_query(){
    var hash = decodeURI(window.location.hash);
    return hash.substr(hash.search('/') +1 , hash.length);
  };

  function get_base_hash(){
    var hash = window.location.hash; 
    return hash.substr(0, hash.search('/'));
  };


  function get_img_url(){
    return $('#image_url').val();
  };

  function get_item_url(){
    return $('#item_url').val();
  };

  function get_rank_select(){
    return $('#rank_select').val();
  };
  
  function get_recommendation_select(){
    return $('#recommendation_select').val();
  };

  function get_item_select(){
    return $('#item_select').val();
  };

  /*
   * Url Generators
   */
  function generate_img_url(id){
    return encodeURI(get_img_url().replace('#{id}', id));
  };

  function generate_item_img_src(){
    var query = recommendation_data.length ? recommendation_data[0][get_item_select()] : get_query();
    return encodeURI(get_img_url().replace('#{id}', query));
  };


  /*
  * Event Handlers
  */
  function fire_show_details(data){
    data = JSON.parse(data);
    data = $.mortar_data.util.get_largest_array(data)
    generate_col_selector_options('#item_select', data);
    generate_col_selector_options('#recommendation_select', data);
    generate_col_selector_options('#rank_select', data);
    recommendation_data = data;
    set_item_select(ITEM_KEY);
    set_recommendation_select(RECOMMENDATION_KEY);
    set_rank_select(RANK_KEY);
    generate_recommendation_list(data);
    //set_img_src('#item_img', generate_item_img_src());
    set_img_src();
    
  };

  function fire_detail_error(error_message){
  };

  function fire_select_change(data){
    ITEM_KEY = get_item_select();
    RECOMMENDATION_KEY = get_recommendation_select();
    RANK_KEY = get_rank_select();
    put_url_config();
    generate_recommendation_list(data) ;
    //set_img_src('#item_img', generate_item_img_src());
    set_img_src();
  };
 
  /*
   * Handler for clicking update button
   */ 
  function fire_update_url(){
    // = set_img_src('#item_img', generate_item_img_src()); 
    set_img_src();
    set_item_src();
    put_url_config();
  };


  function put_url_config(){
    $.mortar_data.api.put_url_config({
      image_url : get_img_url(),
      item_url : get_item_url(),
      item_key : get_item_select(),
      recommendation_key : get_recommendation_select(),
      rank_key : get_rank_select()
    });
  };

  function generate_col_selector_options(selector_id, recommendations){
    $(selector_id).empty();
    for (key in recommendations[0]){
      if (key.search('column') == 0)  {
        $(selector_id).append('<option>' + key + '</option>');
      }
    }
  };


  function generate_recommendation_list(recommendations){
    $('#recommendation_list').empty();
    for (var i=0; i < recommendations.length; i++){
      var item = recommendations[i]; 
      var span_size = 3;// relative to span12 on bootstrap
      var rec_id = item[get_recommendation_select()];
      var rank = item[get_rank_select()];
      $('#recommendation_list').append(
        '<li class="span' + span_size + '">' + 
          '<div class="well">' + 
            '<a class="thumbnail" href="'+ get_base_hash() + '/'+ rec_id + '">'+
              '<img class="img-polaroid recommendation_image" src="' + get_img_url().replace('#{id}', rec_id)+'" data="'+ rec_id + '"></img>'+
            '</a>' +
            '<h3 class="center text-crop" >Item Id: ' +rec_id + '</h3>' +
            '<h3 class="center">Rank: ' + rank + '</h3>' +
            '<a class="center" target="_blank"  href="' + get_item_url().replace('#{id}', rec_id) + '">To Item Page</a>'+
          '</div>'+
        '</li>'
      );
    };
  };

})();
(function(){
  /*  Controller Functions */
  function init_page(){
    window.onhashchange = function(e) {
      on_hash_change();
    };
    if (window.location.hash == ''){
      window.location.hash = '#browse';
    }
    on_hash_change();
  };


  /*  Event Handlers */
  function on_hash_change(){
    $('#explore_nav li').removeClass('active');
    $('.explore_content').addClass('hidden');
    var hash = window.location.hash;
    debugger;
    if (hash.search('/')>0){
      $('#detail_item').addClass('active');
      $('#detail_content').removeClass('hidden'); 
      $.mortar_data.details_view.init();
    }else{
      if(hash === '#browse'){
        $.mortar_data.browse_view.init();
      }else if(hash === '#search'){
        $.mortar_data.search_view.init();
      }
      $(hash + '_item').addClass('active');  
      $(hash + '_content').removeClass('hidden');
    };
  };

  $(document).ready(function()  {
    init_page();
  });


})();
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
/*
 * Initialize with
 * var mortarTable = new MortarTable(
 *      table_container_id: id of div,
 *      array: [{}, {}...],
 *      options: {
 *          page_limit: how many items before next page,
 *          table_class: custom class for table,
 *          next_callback: event handler for clicking next page,
 *          previous_callback: event hanlder for clicking previous page
 *      }
 */
function MortarTable(table_container_id, array, options){
  this.set_array(array);
  this.table_container_id = table_container_id;
  var now = new Date().getTime();
  now = now.toString() + Math.floor(Math.random()*1000).toString();
  this.table_id = 'table_' + now;
  this.table_header_id = 'table_' + now + '_header';
  this.table_body_id = 'table_' + now + '_body';
  this.next_page_class = 'table_'+ now + '_next_page';
  this.previous_page_class = 'table_'+ now + '_previous_page';
  

  this.table_class = options.table_class || 'table table-bordered table-condensed table-striped';
  this.page_limit = options.page_limit || 10;
  this.index = 0;
  this.fire_next_page_finish = options.next_callback || null;
  this.fire_previous_page_finish = options.previous_callback || null;
  this.clickable_column = options.clickable_column || null;
  this.detail_button = options.detail_button || null;

  return this;
};
/*
 * For resetting array
 */
MortarTable.prototype.set_array = function(array){
  this.array = array;
  this.index = 0;
  this.key_array = [];
  if(this.array.length > 0){
    var k = this.keys(this.array[0]);
    for(var i = 0; i < k.length; i++){
      var key_item = k[i];
      this.key_array.push(key_item);
    }
  }
}

/*
 * Main function to handle drawing.  Should really only need to call this
 */
MortarTable.prototype.draw = function(){
  var array = this.array;
  var table_header = this.table_header_id;
  var table_body = this.table_body_id;
  var table_container = this.table_container_id; 
  var table_id = this.table_id;
  if(this.index == 0){ /* Drawing from brand new array */ 
    this.erase();
    $(table_container).append(
        '<div class="pagination pagination-right">'+
          '<ul>'+
            '<li><button id="" class="btn '+ this.previous_page_class +'">&larr;</button></li>'+
            '<li><button id="" class="btn '+ this.next_page_class + '" >&rarr;</button></li>'+
         ' </ul>'+
        '</div>'+
        '<table id="' + table_id + '" class="' + this.table_class + '">'+
          '<thead id="' + table_header + '"></thead>'+
          '<tbody id="' + table_body + '"></tbody>'+
        '</table>'+
        '<div class="pagination pagination-right">'+
          '<ul>'+
            '<li><button id="" class="btn '+ this.previous_page_class +'">&larr;</button></li>'+
            '<li><button id="" class="btn '+ this.next_page_class + '" >&rarr;</button></li>'+
         ' </ul>'+
        '</div>'
    );
    var that = this;
    //$(this.table_id).tablesorter();
    /* Event handler for next page click */
    $('.'+this.next_page_class).click(function(){ /* Hack because we lose reference to this */
      if (that.index >= that.array.length){
        if(that.fire_next_page_finish) that.fire_next_page_finish();  
      }else{
        that.erase_rows();
        that.draw_body_content();
      }
   
    });
    /* Event handler for back page click */
    $('.'+this.previous_page_class).click(function(){
      if(that.index == 0 || that.index-(that.page_limit + that.row_count) < 0 ){
        if(that.fire_previous_page_finish) that.fire_previous_page_finish(); 
      }else{
        that.index -= (that.page_limit +that.row_count);
        
        that.erase_rows();
        that.draw_body_content();
      }
    });
  }
  this.draw_head_content();
};


/*
 * Erases Entire Table
 */
MortarTable.prototype.erase = function(){
  $(this.table_container_id).empty();
};

/*
 * Erases content rows
 */
MortarTable.prototype.erase_rows = function(){
  $('#'+this.table_body_id).empty();
};

/*
 * Only draws the body tag of the table using the header items as keys for array
 */
MortarTable.prototype.draw_body_content = function(){
  var key_array = this.key_array;
  var row_count = 0;
  for(var i  = this.index; i < this.array.length && row_count < this.page_limit; i++, row_count++){
    
    var row = this.array[i];
    var $table_row = $('#' + this.table_body_id).append('<tr></tr>'); 
    
    $table_row = $('#' + this.table_body_id + ' tr:last');
    if(this.detail_button){
      var link = encodeURI(row['column' + this.detail_button]);
      $table_row.append('<td class="flat-cell">' + 
          '<a class="btn btn-cell btn-primary" href="'+window.location.hash + '/' + link + '">Details</a></td>'
        ); 
    }
    for( var j = 0; j < key_array.length; j++){
      if (this.clickable_column == j){
        $table_row.append('<td><a  href="' + window.location.hash +'/'+ row[key_array[j]] + '">' + row[key_array[j] ] + '</a></td>');
      } else{
        $table_row.append('<td>' + row[key_array[j] ] + '</td>');
      }
    }
  }

  //$(this.table_id).trigger('update');
  this.index += row_count;
  this.row_count = row_count;
};

/*
 * Only draws the body tag of the table using the header items as keys for array
 */
MortarTable.prototype.draw_head_content = function(){
  var array = this.array,
      key_array = this.key_array,
      table_header = '#' +this.table_header_id,
      table_body = '#'+this.table_body_id;
  if(array.length > 0){
    
    $(table_header).append('<tr></tr>');
    var $header = $(table_header + ' tr');
    if (this.detail_button){
      $header.append('<th></th>'); 
    }
    for(var key = 0; key <  key_array.length; key++){
      $header.append('<th>' + key_array[key] + '</th>'); 
    }
    this.draw_body_content();
    
  }
};


/**
 * Hack to get keys
 */
MortarTable.prototype.keys = function(hash){
  var keys = [];
  for(var i in hash) if (hash.hasOwnProperty(i)){
    keys.push(i);
  }
  return keys;
}


