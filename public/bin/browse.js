(function(){
  var current_index = 1;
  var browse_table;
  /*  Controller Functions */
  function init_browse(){
    browse_table = new MortarTable('#browse_table',[], {
      fire_next_page : fire_next_page,
      fire_previous_page : fire_previous_page
    });
    
    get_browse();
  }

  /**
   * Makes api call to /api/v1/browse
   */
  function get_browse(){
    debugger;
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
    // server returned no error
    if(data_parsed.error == null){
      $('#browse_error_row').addClass('hidden');
      var largest_array = []; //only one array will have content, so pick the largest
      var count = 0;
      for(key in data_parsed){
        if(data_parsed[key] instanceof Array){
          var curr_array = data_parsed[key];
          // biggest array
          if(curr_array.length > count){
            count  = curr_array.length;
            largest_array = curr_array;
          }
        }
      }
      current_index += largest_array.length; //update current index
      browse_table.set_array(largest_array);
      browse_table.draw();
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
    if(current_index - (get_browse_by()*2) > 0){
      current_index -= (get_browse_by()*2);
      get_browse(); 
    }
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

  $(document).ready(function()  {
      init_browse(); 
  });

})();

