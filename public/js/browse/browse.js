(function(){
  var current_index = 1;
  /*  Controller Functions */
  function init_browse(){

    $('#browse_next_page').on('click', fire_next_page);
    $('#browse_previous_page').on('click', fire_previous_page);
    get_browse();
  }

  function get_browse(){
    $.mortar_data.api.get_browse(
      get_browse_by(), //quantity 
      current_index, //index to start browse
      '', //directory to browse by 
      fire_reload_table,
      function(){
        console.log('error');
      }
    ); 
  }


  /*
   * data - expect to be an object where each key leads to an array
   */
  function fire_reload_table(data){
    var data_parsed = JSON.parse(data);
    var largest_array = []; //only one array will have content, so pick the largest
    var count = 0;
    for(key in data_parsed){
      var curr_array = data_parsed[key];
      if(curr_array.length > count){
        count  = curr_array.length;
        largest_array = curr_array;
      }
    }
    current_index += largest_array.length; //update current index
    $.mortar_data.widgets.draw_table(
              '#browse_table_header', 
              '#browse_table_body', 
              largest_array
          );
    console.log(current_index);
    if(current_index > (get_browse_by() + 1))
      $('#browse_previous_page').removeAttr('disabled');
    else
      $('#browse_previous_page').attr('disabled', 'disabled');
      
      
      
  }


  /*
   *
   */
  function fire_next_page(){
    get_browse(); 
  }
  
  function fire_previous_page(){
    current_index -= (get_browse_by()*2);
    get_browse(); 
  }

  function get_browse_by(){
    return 50; 
  }

  $(document).ready(function()  {
      init_browse(); 
  });


})();

