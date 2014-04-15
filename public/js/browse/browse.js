$.mortar_data = $.mortar_data || {};
$.mortar_data.browse_view = $.mortar_data.browse_view || {};

$.mortar_data.browse_view.current_index = $.mortar_data.browse_view.current_index || 1;

(function(){

  $.mortar_data.browse_view.init = function(){
    init_browse();  
    $.mortar_data.browse_view.exists = true;
  }

  $.mortar_data.browse_view.is_rendered = function(){
    return $.mortar_data.browse_view.exists; 
  };

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
      get_current_index(), //index to start browse
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
      if(largest_array.length > 0){
        set_current_index((Math.floor(get_current_index()/get_browse_by() ) + 1 ) * 50 + 1);
        browse_table.set_array(largest_array);
        browse_table.draw();
      } else{
      } 
     
    } else{
      fire_browse_error(data_parsed.error);
    }
    //Checks indexed number for browse
    if(get_current_index() > (get_browse_by() + 1))
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
    set_current_index( (Math.floor(get_current_index()/get_browse_by())-2)*50 +1);
    set_current_index(get_current_index() <=0 ? 1 : get_current_index());
    get_browse(); 
      
  };

  function set_current_index(value){
    $.mortar_data.browse_view.current_index = value;
  };

  function get_current_index(){
    return $.mortar_data.browse_view.current_index; 
  };

  function fire_browse_update(){
    set_current_index(1);
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

